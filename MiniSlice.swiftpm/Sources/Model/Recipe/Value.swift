enum Value: Hashable, CustomStringConvertible {
    case int(Int)
    case float(Double)
    case cuboid(Cuboid)
    
    var description: String {
        switch self {
        case .int(let value):
            return String(value)
        case .float(let value):
            return String(value)
        case .cuboid(let value):
            return String(describing: value)
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
