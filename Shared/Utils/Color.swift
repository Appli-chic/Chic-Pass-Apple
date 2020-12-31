//
// Created by Lazyos on 29/12/2020.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
                .sRGB,
                red: Double(r) / 255,
                green: Double(g) / 255,
                blue:  Double(b) / 255,
                opacity: Double(a) / 255
        )
    }

    public func rgbToHex() -> String {
        var r:CGFloat = cgColor!.components![0]
        var g:CGFloat = cgColor!.components![1]
        var b:CGFloat = cgColor!.components![2]
        var a:CGFloat = cgColor!.alpha

        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format: "#%06x", rgb)
    }
}

//import UIKit
//
//extension UIColor {
//    convenience init?(hex: String) {
//        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
//        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
//
//        var rgb: UInt64 = 0
//
//        var r: CGFloat = 0.0
//        var g: CGFloat = 0.0
//        var b: CGFloat = 0.0
//        var a: CGFloat = 1.0
//
//        let length = hexSanitized.count
//
//        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
//            return nil
//        }
//
//        if length == 6 {
//            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
//            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
//            b = CGFloat(rgb & 0x0000FF) / 255.0
//
//        } else if length == 8 {
//            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
//            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
//            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
//            a = CGFloat(rgb & 0x000000FF) / 255.0
//
//        } else {
//            return nil
//        }
//
//        self.init(red: r, green: g, blue: b, alpha: a)
//    }
//
//    // MARK: - Computed Properties
//    var toHex: String? {
//        return toHex()
//    }
//
//    // MARK: - From UIColor to String
//    func toHex(alpha: Bool = false) -> String? {
//        guard let components = cgColor.components, components.count >= 3 else {
//            return nil
//        }
//
//        let r = Float(components[0])
//        let g = Float(components[1])
//        let b = Float(components[2])
//        var a = Float(1.0)
//
//        if components.count >= 4 {
//            a = Float(components[3])
//        }
//
//        if alpha {
//            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
//        } else {
//            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
//        }
//    }
//}
