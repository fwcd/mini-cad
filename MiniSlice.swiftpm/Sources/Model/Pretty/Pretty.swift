/// A value that can be formatted using a `Formatter`.
protocol Pretty {
    func pretty(formatter: Formatter) -> String
}

extension Pretty {
    func pretty() -> String {
        pretty(formatter: .init())
    }
}
