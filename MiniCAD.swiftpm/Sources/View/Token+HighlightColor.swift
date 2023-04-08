import SwiftUI

extension Token.Kind {
    func highlightColor(colorScheme: ColorScheme) -> Color? {
        if isKeyword {
            switch colorScheme {
            case .light: return Color(red: 0.6, green: 0.3, blue: 0.2)
            default: return .accentColor
            }
        }
        if isComment {
            switch colorScheme {
            case .light: return Color(red: 0, green: 0.5, blue: 0.1)
            default: return .green
            }
        }
        if isString {
            switch colorScheme {
            case .light: return Color(red: 0.7, green: 0.4, blue: 0)
            default: return .orange
            }
        }
        return nil
    }
}
