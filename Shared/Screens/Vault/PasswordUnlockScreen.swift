//
// Created by Lazyos on 29/12/2020.
//

import SwiftUI
import os

struct PasswordUnlockScreen: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var vaultData: VaultData

    @State private var password = ""
    @State private var hasError = false
    @State private var isLoading = false
    @State var focused: [Bool] = [true]

    var vault: Vault

    var body: some View {
        LoadingView(isShowing: $isLoading) {
            VStack {
                Image(systemName: "lock.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                        .padding(.top, 32)
                        .padding(.bottom)

                Form {
                    Section(header: Text("unlock_vault")) {
                        PasswordField(label: "password", keyboardType: .default, returnVal: .done, tag: 0,
                                isCheckingPasswordStrength: false, isFocusable: self.$focused, password: $password)
                    }
                }
            }
        }
                .background(Color(UIColor.secondarySystemBackground))
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { mode.wrappedValue.dismiss() }) {
                            Text("cancel")
                        }
                                .disabled(isLoading)
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { checkPassword() }) {
                            Text("unlock")
                        }
                                .disabled(isLoading)
                    }
                }
                .alert(isPresented: $hasError) { () -> Alert in
                    Alert(title: Text("error"), message: Text("wrong_password"), dismissButton: .default(Text("ok")))
                }
                .navigationBarTitle("vault")
                .navigationBarTitleDisplayMode(.inline)
                .onTapGesture {
                    hideKeyboard()
                }
                .allowAutoDismiss {
                    !isLoading
                }
                .animation(.none)
    }

    private func checkPassword() {
        hideKeyboard()
        isLoading = true

        DispatchQueue.global().async {
            do {
                let signature = try Security.decryptData(key: password, data: vault.signature!, reloadAes: true)

                if signature == Security.signature {
                    DispatchQueue.main.async {
                        vaultData.isMainScreenActive.toggle()
                        vaultData.vault = vault
                        vaultData.password = password
                        isLoading = false
                        mode.wrappedValue.dismiss()
                    }
                } else {
                    isLoading = false
                    hasError.toggle()
                }
            } catch {
                let nsError = error as NSError
                let defaultLog = Logger()
                defaultLog.error("Error checking a vault password: \(nsError)")

                isLoading = false
                hasError.toggle()
            }
        }
    }
}