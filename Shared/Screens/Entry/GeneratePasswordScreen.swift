//
// Created by Applichic on 12/29/20.
//

import SwiftUI

struct GeneratePasswordScreen: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    @State private var height: CGFloat = .zero
    @State private var nbWords: Double = 6
    @State private var hasUppercase = true
    @State private var hasNumber = true
    @State private var hasSymbol = true
    @State private var password = ""

    var body: some View {
        Form {
            Section(header: Text("password")) {
                HStack {
                    GeometryReader { geometry in
                        PasswordAttributed(text: password, width: geometry.size.width - 16, dynamicHeight: $height) {
                            $0.attributedText = PasswordAttributed.colorizePassword(password: password, isSecure: false)
                        }.frame(minHeight: height)
                    }

                    Image(systemName: "eye.slash.fill")
                            .foregroundColor(Color(UIColor.systemBlue))
                            .padding(.leading)
                }.frame(minHeight: height)
            }

            Section {
                HStack {
                    Text("Words").padding(.trailing)
                    Slider(value: $nbWords, in: 1...20, step: 1, onEditingChanged: { _ in generatePassword() })
                    Text("\(Int(nbWords))").padding(.leading).frame(width: 40)
                }
            }

            Section(header: Text("Options")) {
                Toggle(isOn: $hasUppercase) {
                    Text("Uppercase")
                }

                Toggle(isOn: $hasNumber) {
                    Text("Number")
                }

                Toggle(isOn: $hasSymbol) {
                    Text("Symbol")
                }
            }
        }
                .navigationBarTitle("generate_password")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { mode.wrappedValue.dismiss() }) {
                            Text("ok")
                        }
                    }
                }
                .allowAutoDismiss {
                    false
                }
    }

    private func generatePassword() {
        password = ""

        // Create the password
        for _ in 0...Int(nbWords) {
            let index = Int.random(in: 0..<words.count)
            var word = words[index]

            if hasUppercase {
                let uppercaseLuck = Int.random(in: 0..<10)

                if uppercaseLuck >= 8 {
                    word = word.lastUppercased
                } else if uppercaseLuck >= 4 {
                    word = word.firstUppercased
                }
            }

            if hasNumber {
                let numberLuck = Int.random(in: 0..<10)

                if numberLuck >= 6 {
                    let numberLuck = Int.random(in: 0..<numbers.count)
                    word += numbers[numberLuck]
                }
            }

            if hasSymbol {
                let symbolLuck = Int.random(in: 0..<10)

                if symbolLuck >= 6 {
                    let symbolLuck = Int.random(in: 0..<specialCharacters.count)
                    word += specialCharacters[symbolLuck]
                }
            }

            word += " "

            password += word
        }
    }
}