//
// Created by Lazyos on 29/12/2020.
//

import SwiftUI

#if os(macOS)
import AppKit
#endif

extension Color {
    #if os(iOS)
    var uiColor: UIColor { .init(self) }
    #else
    var nsColor: NSColor { .init(self) }
    #endif
    
    typealias RGBA = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)

    var rgba: RGBA? {
        var (r,g,b,a): RGBA = (0,0,0,0)
        
        #if os(iOS)
        return uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) ? (r,g,b,a) : nil
        #else
        return (r,g,b,a)
        #endif
    }

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

    var hexaRGB: String? {
        guard let rgba = rgba else { return nil }
        return String(format: "#%02x%02x%02x",
                Int(rgba.red*255),
                Int(rgba.green*255),
                Int(rgba.blue*255))
    }

    var hexaRGBA: String? {
        guard let rgba = rgba else { return nil }
        return String(format: "#%02x%02x%02x%02x",
                Int(rgba.red * 255),
                Int(rgba.green * 255),
                Int(rgba.blue * 255),
                Int(rgba.alpha * 255))
    }
}
