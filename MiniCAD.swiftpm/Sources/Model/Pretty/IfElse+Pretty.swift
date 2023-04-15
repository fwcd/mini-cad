extension IfElse: Pretty {
    func pretty(formatter: Formatter) -> String {
        "if \(condition.pretty(formatter: formatter)) \(formatter.blockOpener)"
            + ifBlock.pretty(formatter: formatter.indented)
            + formatter.blockCloser
            + (elseBlock.map { block in
                " else \(formatter.blockOpener)"
                    + block.pretty(formatter: formatter.indented)
                    + formatter.blockCloser
            } ?? "")
    }
}

extension IfElse: CustomStringConvertible {
    var description: String {
        pretty()
    }
}
