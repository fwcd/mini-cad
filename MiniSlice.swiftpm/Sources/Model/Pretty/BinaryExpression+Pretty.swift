extension BinaryExpression {
    func pretty(formatter: Formatter = .init()) -> String {
        switch self {
        case let .range(lower, upper):
            return "\(lower.pretty(formatter: formatter))..<\(upper.pretty(formatter: formatter))"
        case let .closedRange(lower, upper):
            return "\(lower.pretty(formatter: formatter))...\(upper.pretty(formatter: formatter))"
        }
    }
}

extension BinaryExpression: CustomStringConvertible {
    var description: String {
        pretty()
    }
}
