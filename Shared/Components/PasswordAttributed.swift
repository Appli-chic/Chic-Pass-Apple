//
// Created by Applichic on 12/29/20.
//

import SwiftUI

let uppercase = [
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
    "U", "V", "W", "X", "Y", "Z"
]

let numbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

let specialCharacters = [
    "!", "@", "#", "%", "&", "*", ","
]

let words = ["ability", "able", "about", "above", "accept", "according", "account", "across", "act", "action", "activity",
"actually", "add", "address", "administration", "admit", "adult", "affect", "after", "again", "against", "age",
"agency", "agent", "ago", "agree", "agreement", "ahead", "air", "all", "allow", "almost", "alone", "along", "already",
"also", "although", "always", "american", "among", "amount", "analysis", "and", "animal", "another", "answer"]

struct PasswordAttributed: UIViewRepresentable {

    typealias TheUIView = UILabel

    var text: String
    var width: CGFloat
    @Binding var dynamicHeight: CGFloat

    var configuration = { (view: TheUIView) in

    }

    func makeUIView(context: UIViewRepresentableContext<Self>) -> TheUIView {
        let label = TheUIView()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = width
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.text = text

        return label
    }

    func updateUIView(_ uiView: TheUIView, context: UIViewRepresentableContext<Self>) {
        configuration(uiView)

        DispatchQueue.main.async {
            dynamicHeight = uiView.sizeThatFits(CGSize(width: uiView.bounds.width, height: CGFloat.greatestFiniteMagnitude)).height
        }
    }

    static func colorizePassword(password: String, isSecure: Bool) -> NSMutableAttributedString {
        if !isSecure && !password.isEmpty {
            let attributedPassword = NSMutableAttributedString.init(string: password)

            for index in 0...password.count - 1 {
                let range = NSRange(location: index, length: 1)

                if uppercase.contains(String(password.character(at: index)!)) {
                    attributedPassword.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemBlue, range: range)
                } else if numbers.contains(String(password.character(at: index)!)) {
                    attributedPassword.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemGreen, range: range)
                } else {
                    attributedPassword.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.label, range: range)
                }

                attributedPassword.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 17), range: range)
            }

            return attributedPassword
        }

        if isSecure && !password.isEmpty {
            let attributedPassword = NSMutableAttributedString.init(string: password)

            for index in 0...password.count - 1 {
                let range = NSRange(location: index, length: 1)
                attributedPassword.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 17), range: range)
                attributedPassword.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.label, range: range)
            }

            return attributedPassword
        }

        return NSMutableAttributedString.init(string: password)
    }
}
