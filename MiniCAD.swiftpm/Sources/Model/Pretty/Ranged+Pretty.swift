extension Ranged: Pretty where Wrapped: Pretty {
    func pretty(formatter: Formatter) -> String {
        wrappedValue.pretty(formatter: formatter)
    }
}
