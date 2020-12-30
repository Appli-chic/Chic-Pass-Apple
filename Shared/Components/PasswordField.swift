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
                GeometryReader { geometry in
                    TextFieldTyped(keyboardType: keyboardType, returnVal: returnVal, tag: tag,
                            placeholder: NSLocalizedString(label, comment: "hint"),
                            isSecureTextEntry: isHidden, capitalization: .none, text: $password,
                            isFocusable: $isFocusable)
                            .disableAutocorrection(true)
                            .frame(maxWidth: geometry.size.width)
                }

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
                    .foregroundColor(Color(.systemRed))
        } else if password.count < 10 {
            return Text("medium")
                    .padding([.top, .bottom])
                    .font(.callout)
                    .foregroundColor(Color(.systemOrange))
        } else if password.count < 15 {
            return Text("strong")
                    .padding([.top, .bottom])
                    .font(.callout)
                    .foregroundColor(Color(.systemGreen))
        } else {
            return Text("very_strong")
                    .padding([.top, .bottom])
                    .font(.callout)
                    .foregroundColor(Color(.systemGreen))
        }
    }

    static func getGeneratedPasswordColor(password: String) -> Color {
        if password.count < 20 {
            return Color(.systemRed)
        } else if password.count < 45 {
            return Color(.systemOrange)
        } else if password.count < 90 {
            return Color(.systemGreen)
        } else {
            return Color(.systemGreen)
        }
    }

    static func getGeneratedPasswordText(password: String) -> String {
        if password.count < 20 {
            return NSLocalizedString("weak", comment: "Password Strength")
        } else if password.count < 45 {
            return NSLocalizedString("medium", comment: "Password Strength")
        } else if password.count < 90 {
            return NSLocalizedString("strong", comment: "Password Strength")
        } else {
            return NSLocalizedString("very_strong", comment: "Password Strength")
        }
    }
}