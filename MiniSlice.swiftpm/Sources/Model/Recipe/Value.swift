/// A value within the language of recipes.
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
