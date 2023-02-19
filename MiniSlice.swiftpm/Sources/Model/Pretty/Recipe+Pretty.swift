extension Recipe: Pretty {
    func pretty(formatter: Formatter) -> String {
        statements.map { $0.wrappedValue.pretty(formatter: formatter) }.joined(separator: formatter.lineBreak)
    }
}

extension Recipe: CustomStringConvertible {
    var description: String {
        pretty()
    }
}
