//
// Created by Lazyos on 31/12/2020.
//

import SwiftUI
import os

struct BiometryCheckScreen: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var vaultData: VaultData

    @State private var password = ""
    @State private var hasError = false
    @State private var isLoading = false
    @State private var focused: [Bool] = [true]

    public var onPasswordChecked: (String) -> Void

    var body: some View {
        #if os(iOS)
        displayContent()
            .navigationBarTitleDisplayMode(.inline)
            .allowAutoDismiss {
                !isLoading
            }
            .animation(.none)
        #else
        displayContent()
        #endif
    }
    
    private func displayContent() -> some View {
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
                        #if os(iOS)
                        PasswordField(label: "password", keyboardType: .default, returnVal: .done, tag: 0,
                                isCheckingPasswordStrength: false, isFocusable: self.$focused, password: $password)
                        #else
                        SecureField("password", text: $password)
                        #endif
                    }
                }
            }
        }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(action: { mode.wrappedValue.dismiss() }) {
                            Text("cancel")
                        }
                                .disabled(isLoading)
                    }

                    ToolbarItem(placement: .confirmationAction) {
                        Button(action: { checkPassword() }) {
                            Text("unlock")
                        }
                                .disabled(isLoading)
                    }
                }
                .alert(isPresented: $hasError) { () -> Alert in
                    Alert(title: Text("error"), message: Text("wrong_password"), dismissButton: .default(Text("ok")))
                }
                .navigationTitle("vault")
                .onTapGesture {
                    #if os(iOS)
                    hideKeyboard()
                    #endif
                }
    }

    private func checkPassword() {
        #if os(iOS)
        hideKeyboard()
        #endif
        isLoading = true

        DispatchQueue.global().async {
            do {
                let signature = try Security.decryptData(key: password, data: vaultData.vault!.signature!, reloadAes: false)

                if signature == Security.signature {
                    DispatchQueue.main.async {
                        isLoading = false
                        onPasswordChecked(password)
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
