enum Expression: Hashable, CustomStringConvertible {
    case identifier(String)
    case literal(Value)
    case call(String, [Expression])
    
    var description: String {
        switch self {
        case .identifier(let ident):
            return ident
        case .literal(let value):
            return "\(value)"
        case .call(let name, let args):
            return "\(name)(\(args.map { "\($0)" }.joined(separator: ", ")))"
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
