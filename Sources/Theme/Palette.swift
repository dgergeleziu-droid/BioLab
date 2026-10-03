import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:  (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:  (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB,
                  red: Double(r)/255, green: Double(g)/255,
                  blue: Double(b)/255, opacity: Double(a)/255)
    }
}

/// Палитра BioLab — тёмная с зелёным акцентом
enum Palette {
    // Фон
    static let background   = Color(hex: "#0E1512")
    static let backgroundHi = Color(hex: "#141E19")
    static let surface      = Color(hex: "#1B2822")
    static let surfaceHi    = Color(hex: "#243830")
    static let stroke       = Color(hex: "#2E453B")

    // Зелёный (главный акцент)
    static let green        = Color(hex: "#34D399")
    static let greenDark    = Color(hex: "#059669")
    static let greenLight   = Color(hex: "#6EE7B7")
    static let cyan         = Color(hex: "#22D3EE")

    // Цвета органелл
    static let nucleus      = Color(hex: "#8B5CF6")   // ядро
    static let mito         = Color(hex: "#F59E0B")   // митохондрия
    static let chloro       = Color(hex: "#10B981")   // хлоропласт
    static let ribosome     = Color(hex: "#EC4899")   // рибосома
    static let membrane     = Color(hex: "#60A5FA")   // мембрана

    // Статусы
    static let danger       = Color(hex: "#EF4444")
    static let warning      = Color(hex: "#F59E0B")
    static let gold         = Color(hex: "#FBBF24")

    // Текст
    static let textPrimary   = Color(hex: "#F1F5F9")
    static let textSecondary = Color(hex: "#A1A9B3")
    static let textDim       = Color(hex: "#6B7280")
}
