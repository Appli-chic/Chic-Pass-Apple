//
// Created by Lazyos on 29/12/2020.
//

import SwiftUI
import os
import LocalAuthentication

struct PasswordUnlockScreen: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var vaultData: VaultData

    @State private var password = ""
    @State private var hasError = false
    @State private var isLoading = false
    @State var focused: [Bool] = [true]

    @Binding var vault: Vault

    private func checkBiometrics() {
        if !vaultData.isMainScreenActive {
            let preferences = UserDefaults.standard
            if preferences.dictionary(forKey: biometryPasswordsKey) != nil {
                let dictionary = preferences.dictionary(forKey: biometryPasswordsKey)!

                if dictionary[vault.id!.uuidString] != nil {
                    let password = dictionary[vault.id!.uuidString] as! String
                    unlockThroughMetrics(passwordSaved: password)
                }
            }
        }
    }

    private func unlockThroughMetrics(passwordSaved: String) {
        isLoading = true

        let context = LAContext()
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock your vault") { success, error in
            if success {
                do {
                    let signature = try Security.decryptData(key: passwordSaved, data: vault.signature!, reloadAes: true)

                    if signature == Security.signature {
                        DispatchQueue.main.async {
                            vaultData.isMainScreenActive.toggle()
                            vaultData.vault = vault
                            vaultData.password = password
                            isLoading = false
                            mode.wrappedValue.dismiss()
                        }
                    }
                } catch {
                    let nsError = error as NSError
                    let defaultLog = Logger()
                    defaultLog.error("Error decrypting the password: \(nsError)")

                    isLoading = false
                }
            }
        }
    }

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
                    #if os(iOS)
                    hideKeyboard()
                    #endif
                }
                .allowAutoDismiss {
                    !isLoading
                }
                .animation(.none)
                .onAppear {
                    checkBiometrics()
                }
    }

    private func checkPassword() {
        #if os(iOS)
        hideKeyboard()
        #endif
        isLoading = true

        DispatchQueue.global().async {
            do {
                let signature = try Security.decryptData(key: password, data: vault.signature!, reloadAes: true)

                if signature == Security.signature {
                    DispatchQueue.main.async {
                        vaultData.isMainScreenActive = true
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
