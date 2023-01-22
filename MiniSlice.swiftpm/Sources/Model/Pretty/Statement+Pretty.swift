extension Statement {
    func pretty(formatter: Formatter = .init()) -> String {
        switch self {
        case let .varBinding(binding):
            return binding.pretty(formatter: formatter)
        case let .expression(expr):
            return expr.pretty(formatter: formatter)
        case let .forLoop(loop):
            return loop.pretty(formatter: formatter)
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
