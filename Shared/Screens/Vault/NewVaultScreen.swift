//
//  NewVault.swift
//  Chic Secret
//
//  Created by Applichic on 12/28/20.
//

import SwiftUI
import os

struct NewVaultScreen: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var vaultData: VaultData

    @State private var isLoading = false
    @State private var name = ""
    @State private var password = ""
    @State private var passwordCheck = ""
    @State private var isErrorAlertShown = false
    @State private var errorMessage = ""
    @State var focused: [Bool] = [true, false, false]

    var body: some View {
        #if os(iOS)
        displayContent()
                .navigationBarTitleDisplayMode(.inline)
                .allowAutoDismiss {
                    !isLoading
                }
        #else
        displayContent()
                .frame(width: 300, height: 300)
                .padding()
        #endif
    }

    private func displayContent() -> some View {
        LoadingView(isShowing: $isLoading) {
            Form {
                Section(footer: Text("explanation_master_password")) {
                    #if os(iOS)
                    TextFieldTyped(keyboardType: .default, returnVal: .next, tag: 0,
                            placeholder: NSLocalizedString("name", comment: "name"),
                            isSecureTextEntry: false, capitalization: .sentences, text: $name, isFocusable: self.$focused)

                    PasswordField(label: "password", keyboardType: .default, returnVal: .next, tag: 1,
                            isCheckingPasswordStrength: true, isFocusable: self.$focused, password: $password)

                    PasswordField(label: "verify_password", keyboardType: .default, returnVal: .done, tag: 2,
                            isCheckingPasswordStrength: false, isFocusable: self.$focused, password: $passwordCheck)
                    #else
                    TextField("name", text: $name)
                    SecureField("password", text: $password)
                    SecureField("verify_password", text: $passwordCheck)
                    #endif
                }
            }
        }
                .navigationTitle("new_vault")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(action: { mode.wrappedValue.dismiss() }) {
                            Text("cancel")
                        }.disabled(isLoading)
                    }

                    ToolbarItem(placement: .confirmationAction) {
                        Button(action: addVault) {
                            Text("add")
                        }.disabled(isLoading)
                    }
                }
                .alert(isPresented: $isErrorAlertShown) {
                    Alert(title: Text("error"), message: Text(NSLocalizedString(errorMessage, comment: "Error message")),
                            dismissButton: .cancel(Text("ok")))
                }
                .onTapGesture {
                    #if os(iOS)
                    hideKeyboard()
                    #endif
                }
    }

    private func addVault() {
        if !isLoading {
            #if os(iOS)
            hideKeyboard()
            #endif

            if name.isEmpty {
                errorMessage = "name_empty"
                isErrorAlertShown.toggle()
                return
            }

            if password.count < 6 {
                errorMessage = "password_too_small"
                isErrorAlertShown.toggle()
                return
            }

            if password != passwordCheck {
                errorMessage = "passwords_different"
                isErrorAlertShown.toggle()
                return
            }

            isLoading = true

            DispatchQueue.global().async {
                do {
                    let signature = try Security.encryptData(key: password, data: Security.signature, reloadAes: true)

                    let newVault = Vault(context: viewContext)
                    newVault.id = UUID.init()
                    newVault.name = name
                    newVault.signature = signature
                    newVault.createdAt = Date()
                    newVault.updatedAt = Date()

                    try viewContext.save()

                    DispatchQueue.main.async {
                        vaultData.isMainScreenActive = true
                        vaultData.vault = newVault
                        vaultData.password = password
                        isLoading = false
                        mode.wrappedValue.dismiss()
                    }
                } catch {
                    let nsError = error as NSError
                    let defaultLog = Logger()
                    defaultLog.error("Error creating a vault: \(nsError)")
                    isLoading = false
                }
            }
        }
    }
}
