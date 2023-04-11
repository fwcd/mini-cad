extension CallArgument: Pretty {
    func pretty(formatter: Formatter) -> String {
        (label.map { "\($0): " } ?? "") + value.pretty(formatter: formatter)
    }
}

extension CallArgument: CustomStringConvertible {
    var description: String {
        pretty()
    }
}
