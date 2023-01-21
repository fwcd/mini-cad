enum Expression: Hashable, CustomStringConvertible {
    case identifier(String)
    case intLiteral(Int)
    case floatLiteral(Double)
    case call(String, [Expression])
    
    var description: String {
        switch self {
        case .identifier(let ident):
            return ident
        case .intLiteral(let value):
            return String(value)
        case .floatLiteral(let value):
            return String(value)
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
        self = .intLiteral(value)
    }
}

extension Expression: ExpressibleByFloatLiteral {
    init(floatLiteral value: Double) {
        self = .floatLiteral(value)
    }
}
