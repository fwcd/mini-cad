enum ParseError: Error, CustomStringConvertible {
    case expected(Token, actual: Token?)
    case expectedIdentifier(actual: Token?)
    case expectedExpression(actual: Token?)
    
    var description: String {
        switch self {
        case let .expected(expected, actual: actual):
            return "Expected \(expected) but got \(actual.map { "\($0)" } ?? "nil")"
        case let .expectedIdentifier(actual: actual):
            return "Expected identifier but got \(actual.map { "\($0)" } ?? "nil")"
        case let .expectedExpression(actual: actual):
            return "Expected expression but got \(actual.map { "\($0)" } ?? "nil")"
        }
    }
}
