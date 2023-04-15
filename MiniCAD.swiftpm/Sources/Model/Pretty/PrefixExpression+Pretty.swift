extension PrefixExpression: Pretty {
    func pretty(formatter: Formatter) -> String {
        "\(op.pretty(formatter: formatter))\(rhs.pretty(formatter: formatter))"
    }
}

extension PrefixExpression: CustomStringConvertible {
    var description: String {
        pretty()
    }
}
