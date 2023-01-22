/// A value within the language of recipes.
enum Value: Hashable {
    case int(Int)
    case float(Double)
    case intRange(Range<Int>)
    case floatRange(Range<Double>)
    case closedIntRange(ClosedRange<Int>)
    case closedFloatRange(ClosedRange<Double>)
    case cuboid(Cuboid)
    
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
    
    // TODO: Should we coerce between closed and half-open ranges?
    
    var asIntRange: Range<Int>? {
        switch self {
        case .intRange(let range):
            return range
        default:
            return nil
        }
    }
    
    var asFloatRange: Range<Double>? {
        switch self {
        case .floatRange(let range):
            return range
        default:
            return nil
        }
    }
    
    var asClosedIntRange: ClosedRange<Int>? {
        switch self {
        case .closedIntRange(let range):
            return range
        default:
            return nil
        }
    }
    
    var asClosedFloatRange: ClosedRange<Double>? {
        switch self {
        case .closedFloatRange(let range):
            return range
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
