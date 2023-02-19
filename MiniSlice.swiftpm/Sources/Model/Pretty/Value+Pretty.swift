extension Value: Pretty {
    func pretty(formatter: Formatter) -> String {
        switch self {
        case .int(let value):
            return String(value)
        case .float(let value):
            return String(value)
        case .string(let value):
            return "\"\(value)\""
        case .bool(let value):
            return value ? "true" : "false"
        case .intRange(let range):
            return "\(range.lowerBound)..<\(range.upperBound)"
        case .floatRange(let range):
            return "\(range.lowerBound)..<\(range.upperBound)"
        case .closedIntRange(let range):
            return "\(range.lowerBound)...\(range.upperBound)"
        case .closedFloatRange(let range):
            return "\(range.lowerBound)...\(range.upperBound)"
        case .mesh(let value):
            // TODO: Produce a prettier description
            return String(describing: value)
        }
    }
}

extension Value: CustomStringConvertible {
    var description: String {
        pretty()
    }
}
