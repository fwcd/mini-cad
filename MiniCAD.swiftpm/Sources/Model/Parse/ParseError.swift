enum ParseError: Error, CustomStringConvertible, Hashable {
    case expected(Token.Kind, actual: Token?)
    case expectedIdentifier(actual: Token?)
    case expectedExpression(actual: Token?)
    case expectedValue(actual: Token?)
    case couldNotParseIntLiteral(token: Token?)
    case couldNotParseFloatLiteral(token: Token?)
    case unimplementedOperator(BinaryOperator, token: Token?)
    
    var token: Token? {
        switch self {
        case let .expected(_, actual: token),
             let .expectedIdentifier(actual: token),
             let .expectedExpression(actual: token),
             let .expectedValue(actual: token),
             let .couldNotParseIntLiteral(token: token),
             let .couldNotParseFloatLiteral(token: token),
             let .unimplementedOperator(_, token: token):
            return token
        }
    }
    
    var baseDescription: String {
        switch self {
        case let .expected(expected, actual: actual):
            return "Expected \(expected) but got \(actual.map { "\($0.kind)" } ?? "nil")"
        case let .expectedIdentifier(actual: actual):
            return "Expected identifier but got \(actual.map { "\($0.kind)" } ?? "nil")"
        case let .expectedExpression(actual: actual):
            return "Expected expression but got \(actual.map { "\($0.kind)" } ?? "nil")"
        case let .expectedValue(actual: actual):
            return "Expected value but got \(actual.map { "\($0.kind)" } ?? "nil")"
        case .couldNotParseIntLiteral(_):
            return "Could not parse int literal"
        case .couldNotParseFloatLiteral(_):
            return "Could not parse float literal"
        case let .unimplementedOperator(op, token: _):
            return "Operator \(op.pretty()) has not been implemented yet"
        }
    }
    
    var description: String {
        (token?.sourceRange.lines.lowerBound).map { "\(baseDescription) at line \($0 + 1)" } ?? baseDescription
    }
}
