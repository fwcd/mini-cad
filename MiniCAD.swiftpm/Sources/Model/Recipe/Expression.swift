/// An expression syntax tree.
enum Expression<Attachment> {
    case identifier(String)
    case literal(Value)
    case prefix(PrefixExpression<Attachment>)
    case binary(BinaryExpression<Attachment>)
    case call(CallExpression<Attachment>)
    
    func map<T>(_ transform: (Attachment) throws -> T) rethrows -> Expression<T> {
        switch self {
        case .identifier(let string):
            return .identifier(string)
        case .literal(let value):
            return .literal(value)
        case .prefix(let prefixExpression):
            return .prefix(try prefixExpression.map(transform))
        case .binary(let binaryExpression):
            return .binary(try binaryExpression.map(transform))
        case .call(let callExpression):
            return .call(try callExpression.map(transform))
        }
    }
}

extension Expression: Equatable where Attachment: Equatable {}

extension Expression: Hashable where Attachment: Hashable {}

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

extension Expression: ExpressibleByBooleanLiteral {
    init(booleanLiteral value: Bool) {
        self = .literal(.bool(value))
    }
}
