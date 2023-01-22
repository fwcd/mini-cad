enum Value: Hashable, CustomStringConvertible {
    case int(Int)
    case float(Double)
    case cuboid(Cuboid)
    case `nil`
    
    var description: String {
        switch self {
        case .int(let value):
            return String(value)
        case .float(let value):
            return String(value)
        case .cuboid(let value):
            return String(describing: value)
        case .nil:
            return "nil"
        }
    }
    
    var asInt: Int? {
        // TODO: Should we do implicit narrowing casts from float -> int?
        switch self {
        case .int(let value):
            return value
        default:
            return nil
        }
    }
    
    var asFloat: Double? {
        switch self {
        case .int(let value):
            return Double(value)
        case .float(let value):
            return value
        default:
            return nil
        }
    }
    
    var asCuboid: Cuboid? {
        switch self {
        case .cuboid(let value):
            return value
        default:
            return nil
        }
    }
    
    var isNil: Bool {
        self == .nil
    }
    
    var nonNil: Self? {
        isNil ? nil : self
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
