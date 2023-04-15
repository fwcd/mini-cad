extension FuncDeclaration: Pretty {
    func pretty(formatter: Formatter) -> String {
        "func \(name)(\(paramNames.joined(separator: ", ")) \(formatter.blockOpener)"
            + block.pretty(formatter: formatter.indented)
            + formatter.blockCloser
    }
}

extension FuncDeclaration: CustomStringConvertible {
    var description: String {
        pretty()
    }
}
