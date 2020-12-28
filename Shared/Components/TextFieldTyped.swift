//
// Created by Applichic on 12/28/20.
//

import SwiftUI

struct TextFieldTyped: UIViewRepresentable {
    let keyboardType: UIKeyboardType
    let returnVal: UIReturnKeyType
    let tag: Int
    let placeholder: String
    let isSecureTextEntry: Bool
    @Binding var text: String
    @Binding var isFocusable: [Bool]

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.placeholder = placeholder
        textField.keyboardType = keyboardType
        textField.returnKeyType = returnVal
        textField.tag = tag
        textField.delegate = context.coordinator
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = isSecureTextEntry

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.isSecureTextEntry = isSecureTextEntry

        if uiView.window != nil {
            if isFocusable[tag] {
                if !uiView.isFirstResponder {
                    uiView.becomeFirstResponder()
                }
            } else {
                uiView.resignFirstResponder()
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: TextFieldTyped

        init(_ textField: TextFieldTyped) {
            parent = textField
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.parent.text = textField.text ?? ""
            }
        }

        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            setFocus(tag: parent.tag)
            return true
        }

        func setFocus(tag: Int) {
            let reset = tag >= parent.isFocusable.count || tag < 0

            if reset || !parent.isFocusable[tag] {
                var newFocus = [Bool](repeatElement(false, count: parent.isFocusable.count))
                if !reset {
                    newFocus[tag] = true
                }

                DispatchQueue.main.async {
                    self.parent.isFocusable = newFocus
                }
            }
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            setFocus(tag: parent.tag + 1)
            return true
        }
    }
}