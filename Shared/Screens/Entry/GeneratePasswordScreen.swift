//
// Created by Applichic on 12/29/20.
//

import SwiftUI

let spaces = [
    NSLocalizedString("space", comment: "spaces"),
    NSLocalizedString("underscore", comment: "spaces"),
    NSLocalizedString("hyphen", comment: "spaces"),
]

struct GeneratePasswordScreen: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    @Binding var password: String

    @State private var height: CGFloat = .zero
    @State private var nbWords: Double = 8
    @State private var hasUppercase = true
    @State private var hasNumber = true
    @State private var hasSymbol = true
    @State private var isHidden = true
    @State private var spaceTypeSelected = 0

    var body: some View {
        Form {
            Section(header: Text("password")) {
                GeometryReader { geometry in
                    PasswordAttributed(text: password, width: geometry.size.width, dynamicHeight: $height) {
                        $0.attributedText = PasswordAttributed.colorizePassword(password: password, isSecure: false)
                    }.frame(minHeight: height)
                }
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        .frame(minHeight: height + 16)

                Text(PasswordField.getGeneratedPasswordText(password: password))
                        .bold()
                        .foregroundColor(Color(.white))
                        .listRowBackground(PasswordField.getGeneratedPasswordColor(password: password))
            }

            Section {
                HStack {
                    Text("words").padding(.trailing)
                    Slider(value: Binding(get: { nbWords }, set: { value in
                        if nbWords != value {
                            nbWords = value
                            generatePassword()
                        }
                    }), in: 1...20, step: 1)
                    Text("\(Int(nbWords))").padding(.leading).frame(width: 40)
                }
            }

            Section(header: Text("options")) {
                Toggle(isOn: Binding(get: { hasUppercase }, set: { value in
                    if hasUppercase != value {
                        hasUppercase = value
                        generatePassword()
                    }
                })) {
                    Text("uppercase")
                }

                Toggle(isOn: Binding(get: { hasNumber }, set: { value in
                    if hasNumber != value {
                        hasNumber = value
                        generatePassword()
                    }
                })) {
                    Text("number")
                }

                Toggle(isOn: Binding(get: { hasSymbol }, set: { value in
                    if hasSymbol != value {
                        hasSymbol = value
                        generatePassword()
                    }
                })) {
                    Text("symbol")
                }
            }

            Section(header: Text("spacing")) {
                Picker("spacing", selection: $spaceTypeSelected) {
                    ForEach(0..<spaces.count) {
                        Text(spaces[$0])
                    }
                }
            }

            Section {
                Button(action: { generatePassword() }) {
                    HStack {
                        Spacer()
                        Text("regenerate_password")
                        Spacer()
                    }
                }
            }
        }
                .onAppear {
                    generatePassword()
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
        for number in 0..<Int(nbWords) {
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

            if number != Int(nbWords) - 1 {
                switch spaceTypeSelected {
                case 0:
                    word += " "
                    break;
                case 1:
                    word += "_"
                    break;
                case 2:
                    word += "-"
                    break;
                default:
                    word += " "
                }
            }

            password += word
        }
    }
}