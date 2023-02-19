extension ForLoop: Pretty {
    func pretty(formatter: Formatter) -> String {
        "for \(name) in \(sequence.pretty(formatter: formatter)) \(formatter.blockOpener)"
            + block.map { $0.wrappedValue.pretty(formatter: formatter.indented) }.joined(separator: formatter.indented.lineBreak)
            + formatter.blockCloser
    }
}

extension ForLoop: CustomStringConvertible {
    var description: String {
        pretty()
    }
}
