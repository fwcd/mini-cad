extension Recipe {
    func pretty(formatter: Formatter = .init()) -> String {
        statements.map { $0.wrappedValue.pretty(formatter: formatter) }.joined(separator: formatter.lineBreak)
    }
}

extension Recipe: CustomStringConvertible {
    var description: String {
        pretty()
    }
}
