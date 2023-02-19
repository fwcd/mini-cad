extension Expression {
    func pretty(formatter: Formatter = .init()) -> String {
        switch self {
        case let .identifier(ident):
            return ident
        case let .literal(value):
            return value.pretty(formatter: formatter)
        case let .binary(binary):
            return binary.pretty(formatter: formatter)
        case let .call(call):
            var formatted = call.identifier
            if !call.args.isEmpty || call.trailingBlock.isEmpty {
                formatted += "(\(call.args.map { $0.pretty(formatter: formatter) }.joined(separator: ", ")))"
            }
            if !call.trailingBlock.isEmpty {
                formatted += " "
                    + formatter.blockOpener
                + call.trailingBlock.map { $0.wrappedValue.pretty(formatter: formatter.indented) }.joined(separator: formatter.indented.lineBreak)
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
