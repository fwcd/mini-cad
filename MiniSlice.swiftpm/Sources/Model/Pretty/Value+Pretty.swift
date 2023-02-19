extension Value: Pretty {
    func pretty(formatter: Formatter) -> String {
        switch self {
        case .int(let value):
            return String(value)
        case .float(let value):
            return String(value)
        case .intRange(let range):
            return "\(range.lowerBound)..<\(range.upperBound)"
        case .floatRange(let range):
            return "\(range.lowerBound)..<\(range.upperBound)"
        case .closedIntRange(let range):
            return "\(range.lowerBound)...\(range.upperBound)"
        case .closedFloatRange(let range):
            return "\(range.lowerBound)...\(range.upperBound)"
        case .cuboid(let value):
            return String(describing: value)
        }
    }
}

extension Value: CustomStringConvertible {
    var description: String {
        pretty()
    }
}
