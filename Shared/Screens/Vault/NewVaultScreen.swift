//
//  NewVault.swift
//  Chic Secret
//
//  Created by Applichic on 12/28/20.
//

import SwiftUI

struct NewVaultScreen: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    @State private var isLoading = false
    @State private var name = ""
    @State private var password = ""
    @State private var passwordCheck = ""
    @State var focused: [Bool] = [true, false, false]

    var body: some View {

        LoadingView(isShowing: $isLoading) {
            Form {
                Section(footer: Text("explanation_master_password")) {
                    TextFieldTyped(keyboardType: .default, returnVal: .next, tag: 0,
                            placeholder: NSLocalizedString("name", comment: "name"),
                            isSecureTextEntry: false, text: $name, isFocusable: self.$focused)

                    PasswordField(label: "password", keyboardType: .default, returnVal: .next, tag: 1,
                            isCheckingPasswordStrength: true, isFocusable: self.$focused, password: $password)

                    PasswordField(label: "verify_password", keyboardType: .default, returnVal: .done, tag: 2,
                            isCheckingPasswordStrength: false, isFocusable: self.$focused, password: $passwordCheck)
                }
            }
        }
                .navigationBarTitle("new_vault", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(action: { mode.wrappedValue.dismiss() }) {
                            Text("cancel")
                        }
                    }

                    ToolbarItem(placement: .confirmationAction) {
                        Button(action: {}) {
                            Text("add")
                        }
                    }
                }
                .onTapGesture {
                    hideKeyboard()
                }
    }
}
