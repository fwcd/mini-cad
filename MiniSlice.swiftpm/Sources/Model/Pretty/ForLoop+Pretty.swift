extension ForLoop: Pretty {
    func pretty(formatter: Formatter) -> String {
        "for \(name) in \(sequence.pretty(formatter: formatter)) \(formatter.blockOpener)"
            + block.pretty(formatter: formatter.indented)
            + formatter.blockCloser
    }
}

extension ForLoop: CustomStringConvertible {
    var description: String {
        pretty()
    }
}
