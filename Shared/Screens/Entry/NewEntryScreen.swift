//
// Created by Lazyos on 29/12/2020.
//

import SwiftUI
import os

struct NewEntryScreen: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    private var fetchRequest: FetchRequest<Category>
    private var categories: FetchedResults<Category> {
        fetchRequest.wrappedValue
    }

    @State private var name = ""
    @State private var username = ""
    @State private var password = ""
    @State private var category: Category?
    @State private var isLoading = false
    @State private var isErrorAlertShown = false
    @State private var isGeneratingPassword = false
    @State private var errorMessage = ""
    @State private var selectedCategoryIndex = 0
    @State private var isAddingCategory = false
    @State var focused: [Bool] = [false, false, false]

    var vaultData: VaultData

    init(vaultData: VaultData) {
        fetchRequest = FetchRequest<Category>(
                entity: Category.entity(),
                sortDescriptors: [NSSortDescriptor(keyPath: \Category.createdAt, ascending: true)],
                predicate: NSPredicate(format: "vault.id == %@", vaultData.vault!.id!.uuidString)
        )

        self.vaultData = vaultData
    }

    var body: some View {
        #if os(iOS)
        displayContent()
            .navigationBarTitleDisplayMode(.inline)
        #else
        displayContent()
        #endif
    }
    
    private func displayContent() -> some View {
        LoadingView(isShowing: $isLoading) {
            ZStack {
                NavigationLink(destination: GeneratePasswordScreen(password: $password), isActive: $isGeneratingPassword) {
                    EmptyView()
                }

                Form {
                    Section {
                        #if os(iOS)
                        TextFieldTyped(keyboardType: .default, returnVal: .next, tag: 0,
                                placeholder: NSLocalizedString("name", comment: "name"),
                                isSecureTextEntry: false, capitalization: .sentences, text: $name, isFocusable: self.$focused)

                        TextFieldTyped(keyboardType: .default, returnVal: .next, tag: 1,
                                placeholder: NSLocalizedString("username_email", comment: "username_email"),
                                isSecureTextEntry: false, capitalization: .none, text: $username, isFocusable: self.$focused)

                        PasswordField(label: "password", keyboardType: .default, returnVal: .done, tag: 2,
                                isCheckingPasswordStrength: false, isFocusable: self.$focused, password: $password)
                        #else
                        TextField("name", text: $name)
                        TextField("username_email", text: $username)
                        SecureField("password", text: $password)
                        #endif

                        Button(action: { isGeneratingPassword.toggle() }) {
                            HStack {
                                Image(systemName: "wand.and.stars")
                                Text("generate_password")
                            }
                        }
                    }

                    Section(header: Text("category")) {
                        Picker("category", selection: $selectedCategoryIndex) {
                            ForEach(Array(categories.enumerated()), id: \.offset) { index, category in
                                Text(category.name!)
                            }
                        }

                        Button(action: { isAddingCategory.toggle() }) {
                            HStack {
                                Text("create_category")
                            }
                        }
                    }
                }
            }
        }
                .navigationTitle("new_password")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(action: {
                            #if os(iOS)
                            hideKeyboard()
                            #endif
                            mode.wrappedValue.dismiss()
                        }) {
                            Text("cancel")
                        }.disabled(isLoading)
                    }

                    ToolbarItem(placement: .confirmationAction) {
                        Button(action: addEntry) {
                            Text("add")
                        }.disabled(isLoading)
                    }
                }
                .sheet(isPresented: $isAddingCategory) {
                    NavigationView {
                        NewCategoryScreen {
                        }
                    }
                }
                .alert(isPresented: $isErrorAlertShown) {
                    Alert(title: Text("error"), message: Text(NSLocalizedString(errorMessage, comment: "Error message")),
                            dismissButton: .cancel(Text("ok")))
                }
    }

    private func addEntry() {
        if !isLoading {
            #if os(iOS)
            hideKeyboard()
            #endif

            if name.isEmpty {
                errorMessage = "name_empty"
                isErrorAlertShown.toggle()
                return
            }

            if password.isEmpty {
                errorMessage = "password_empty"
                isErrorAlertShown.toggle()
                return
            }

            if categories.isEmpty {
                errorMessage = "category_empty"
                isErrorAlertShown.toggle()
                return
            }

            isLoading = true

            DispatchQueue.global().async {
                do {
                    let hash = try Security.encryptData(key: vaultData.password, data: password, reloadAes: false)

                    let entry = Entry(context: viewContext)
                    entry.id = UUID.init()
                    entry.name = name.firstUppercased
                    entry.username = username
                    entry.password = hash
                    entry.createdAt = Date()
                    entry.updatedAt = Date()
                    entry.vault = vaultData.vault
                    entry.category = categories[selectedCategoryIndex]

                    try viewContext.save()

                    DispatchQueue.main.async {
                        isLoading = false
                        mode.wrappedValue.dismiss()
                    }
                } catch {
                    let nsError = error as NSError
                    let defaultLog = Logger()
                    defaultLog.error("Error creating an entry: \(nsError)")
                    isLoading = false
                }
            }
        }
    }
}
