/// An expression syntax tree.
enum Expression: Hashable, CustomStringConvertible {
    case identifier(String)
    case literal(Value)
    case binary(BinaryExpression)
    case call(String, args: [Expression], trailingBlock: [Statement])
    
    var description: String {
        switch self {
        case let .identifier(ident):
            return ident
        case let .literal(value):
            return "\(value)"
        case let .binary(binary):
            return "\(binary)"
        case let .call(name, args, trailingBlock):
            var formatted = name
            if !args.isEmpty || trailingBlock.isEmpty {
                formatted += "(\(args.map { "\($0)" }.joined(separator: ", ")))"
            }
            if !trailingBlock.isEmpty {
                formatted += ([" {"] + trailingBlock.map { $0.description } + ["}"]).joined(separator: "\n")
            }
            return formatted
        }
    }
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
