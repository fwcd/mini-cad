extension PrefixOperator: Pretty {
    func pretty(formatter: Formatter) -> String {
        switch self {
        case .logicalNot: return "!"
        case .negation: return "-"
        }
    }
}
