//
// Created by Applichic on 12/28/20.
//

import SwiftUI

struct PasswordField: View {
    let label: String
    let keyboardType: UIKeyboardType
    let returnVal: UIReturnKeyType
    let tag: Int
    let isCheckingPasswordStrength: Bool
    @Binding var isFocusable: [Bool]
    @Binding var password: String
    @State var isHidden = true

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextFieldTyped(keyboardType: keyboardType, returnVal: returnVal, tag: tag,
                        placeholder: NSLocalizedString(label, comment: "hint"),
                        isSecureTextEntry: isHidden, text: $password,
                        isFocusable: $isFocusable)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .frame(height: 40)

                Button(action: {}) {
                    Image(systemName: isHidden ? "eye.fill" : "eye.slash.fill")
                }.onTapGesture {
                    isHidden.toggle()
                }
            }

            if isCheckingPasswordStrength && password.count > 0 {
                getPasswordStrength()
            }
        }
    }

    private func getPasswordStrength() -> some View {
        if password.count < 6 {
            return Text("weak")
                    .padding([.top, .bottom])
                    .font(.callout)
                    .foregroundColor(.red)
        } else if password.count < 10 {
            return Text("medium")
                    .padding([.top, .bottom])
                    .font(.callout)
                    .foregroundColor(.orange)
        } else if password.count < 15 {
            return Text("strong")
                    .padding([.top, .bottom])
                    .font(.callout)
                    .foregroundColor(.green)
        } else {
            return Text("very_strong")
                    .padding([.top, .bottom])
                    .font(.callout)
                    .foregroundColor(.green)
        }
    }
}