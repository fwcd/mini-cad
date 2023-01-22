extension ForLoop {
    func pretty(formatter: Formatter = .init()) -> String {
        "for \(name) in \(sequence.pretty(formatter: formatter)) \(formatter.blockOpener)"
            + block.map { $0.pretty(formatter: formatter.indented) }.joined(separator: formatter.indented.lineBreak)
            + formatter.blockCloser
    }
}

extension ForLoop: CustomStringConvertible {
    var description: String {
        pretty()
    }
}
