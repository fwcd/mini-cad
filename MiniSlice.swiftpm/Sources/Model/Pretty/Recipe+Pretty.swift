extension Recipe: Pretty {
    func pretty(formatter: Formatter) -> String {
        statements.pretty(formatter: formatter)
    }
}

extension Recipe: CustomStringConvertible {
    var description: String {
        pretty()
    }
}
