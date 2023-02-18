extension VarBinding {
    func pretty(formatter: Formatter = .init()) -> String {
        "let \(name) = \(value.pretty(formatter: formatter))"
    }
}

extension VarBinding: CustomStringConvertible {
    var description: String {
        pretty()
    }
}
