extension Expression {
    func pretty(formatter: Formatter = .init()) -> String {
        switch self {
        case let .identifier(ident):
            return ident
        case let .literal(value):
            return value.pretty(formatter: formatter)
        case let .binary(binary):
            return binary.pretty(formatter: formatter)
        case let .call(name, args, trailingBlock):
            var formatted = name
            if !args.isEmpty || trailingBlock.isEmpty {
                formatted += "(\(args.map { $0.pretty(formatter: formatter) }.joined(separator: ", ")))"
            }
            if !trailingBlock.isEmpty {
                formatted += " "
                    + formatter.blockOpener
                + trailingBlock.map { $0.pretty(formatter: formatter.indented) }.joined(separator: formatter.indented.lineBreak)
                    + formatter.blockCloser
            }
            return formatted
        }
    }
}

extension Expression: CustomStringConvertible {
    var description: String {
        pretty()
    }
}
