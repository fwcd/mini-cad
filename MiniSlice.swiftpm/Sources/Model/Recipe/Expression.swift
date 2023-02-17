/// An expression syntax tree.
enum Expression: Hashable {
    case identifier(String)
    case literal(Value)
    case binary(BinaryExpression)
    case call(CallExpression)
}

extension Expression: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self = .identifier(value)
    }
}

extension Expression: ExpressibleByIntegerLiteral {
    init(integerLiteral value: Int) {
        self = .literal(.int(value))
    }
}

extension Expression: ExpressibleByFloatLiteral {
    init(floatLiteral value: Double) {
        self = .literal(.float(value))
    }
}
