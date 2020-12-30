//
// Created by Applichic on 12/28/20.
//

import SwiftUI
import Combine

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

    }

    func resignKeyboardOnDragGesture() -> some View {
        modifier(ResignKeyboardOnDragGesture())
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        windows
                .filter {
                    $0.isKeyWindow
                }
                .first?
                .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged { _ in
        UIApplication.shared.endEditing(true)
    }

    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}
#endif