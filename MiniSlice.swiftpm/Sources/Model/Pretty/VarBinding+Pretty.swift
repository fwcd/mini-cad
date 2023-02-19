extension VarBinding: Pretty {
    func pretty(formatter: Formatter) -> String {
        "let \(name) = \(value.pretty(formatter: formatter))"
    }
}

extension VarBinding: CustomStringConvertible {
    var description: String {
        pretty()
    }
}
