extension Statement: Pretty {
    func pretty(formatter: Formatter) -> String {
        switch self {
        case let .varBinding(binding):
            return binding.pretty(formatter: formatter)
        case let .expression(expr):
            return expr.pretty(formatter: formatter)
        case let .forLoop(loop):
            return loop.pretty(formatter: formatter)
        case let .ifElse(ifElse):
            return ifElse.pretty(formatter: formatter)
        case let .funcDeclaration(decl):
            return decl.pretty(formatter: formatter)
        case .blank:
            return ""
        }
    }
}

extension Statement: CustomStringConvertible {
    var description: String {
        pretty()
    }
}
