extension BinaryExpression {
    func pretty(formatter: Formatter = .init()) -> String {
        // TODO: Use precedence/associativity to parenthesize minimally
        return "(\(lhs.pretty(formatter: formatter)) \(op.pretty(formatter: formatter)) \(rhs.pretty(formatter: formatter)))"
    }
}

extension BinaryExpression: CustomStringConvertible {
    var description: String {
        pretty()
    }
}
