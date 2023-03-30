import SwiftUI

extension Token.Kind {
    var highlightColor: Color? {
        if isKeyword {
            return .accentColor
        }
        if isComment {
            return .green
        }
        if isString {
            return .orange
        }
        return nil
    }
}
