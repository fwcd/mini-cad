enum Value: Hashable, CustomStringConvertible {
    case int(Int)
    case float(Double)
    
    var description: String {
        switch self {
        case .int(let value):
            return String(value)
        case .float(let value):
            return String(value)
        }
    }
}

extension Value: ExpressibleByIntegerLiteral {
    init(integerLiteral value: Int) {
        self = .int(value)
    }
}

extension Value: ExpressibleByFloatLiteral {
    init(floatLiteral value: Double) {
        self = .float(value)
    }
}
