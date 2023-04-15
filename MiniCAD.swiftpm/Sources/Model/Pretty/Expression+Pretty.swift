extension Expression: Pretty {
    func pretty(formatter: Formatter) -> String {
        switch self {
        case let .identifier(ident):
            return ident
        case let .literal(value):
            return value.pretty(formatter: formatter)
        case let .prefix(prefix):
            return prefix.pretty(formatter: formatter)
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
                    + call.trailingBlock.pretty(formatter: formatter.indented)
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
