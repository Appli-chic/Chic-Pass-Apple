//
// Created by Lazyos on 29/12/2020.
//

import SwiftUI
import os

struct NewCategoryScreen: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var vaultData: VaultData

    var onNewCategoryCreated: () -> Void

    @State private var name = ""
    @State private var selectedStrength = 0
    @State private var selectedIcon = previewIconList[0]
    @State private var isLoading = false
    @State private var isErrorAlertShown = false
    @State private var errorMessage = ""
    @State private var color = Color.blue

    init(onNewCategoryCreated: @escaping () -> Void = {
    }) {
        self.onNewCategoryCreated = onNewCategoryCreated
    }

    var body: some View {
        LoadingView(isShowing: $isLoading) {
            ZStack {
                Form {
                    Section {
                        TextField("name", text: $name)
                    }

                    Section(header: Text("icon_color")) {
                        IconPicker(selectedIcon: $selectedIcon, color: color)
                        ColorPickerItem(color: $color)
                    }
                }
            }
        }
                .navigationBarTitle("new_category")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { mode.wrappedValue.dismiss() }) {
                            Text("cancel")
                        }.disabled(isLoading)
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: addCategory) {
                            Text("add")
                        }.disabled(isLoading)
                    }
                }
                .alert(isPresented: $isErrorAlertShown) {
                    Alert(title: Text("error"), message: Text(NSLocalizedString(errorMessage, comment: "Error message")),
                            dismissButton: .cancel(Text("ok")))
                }
    }

    private func addCategory() {
        if !isLoading {
            hideKeyboard()

            if name.isEmpty {
                errorMessage = "name_empty"
                isErrorAlertShown.toggle()
                return
            }

            isLoading = true

            DispatchQueue.global().async {
                do {
                    let newCategory = Category(context: viewContext)
                    newCategory.id = UUID.init()
                    newCategory.name = name.firstUppercased
                    newCategory.color = color.rgbToHex()
                    newCategory.icon = selectedIcon.icon
                    newCategory.createdAt = Date()
                    newCategory.updatedAt = Date()
                    newCategory.vault = vaultData.vault!

                    try viewContext.save()

                    DispatchQueue.main.async {
                        onNewCategoryCreated()
                        mode.wrappedValue.dismiss()
                    }
                } catch {
                    let nsError = error as NSError
                    let defaultLog = Logger()
                    defaultLog.error("Error creating a category: \(nsError)")
                    isLoading = false
                }
            }
        }
    }
}