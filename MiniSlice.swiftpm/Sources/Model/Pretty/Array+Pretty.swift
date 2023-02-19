extension Array: Pretty where Element: Pretty {
    func pretty(formatter: Formatter) -> String {
        map { $0.pretty(formatter: formatter) }.joined(separator: formatter.lineBreak)
    }
}
