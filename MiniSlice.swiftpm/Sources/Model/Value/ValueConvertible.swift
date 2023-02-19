/// Conformance indicates that the type is convertible to and from `Value`.
protocol ValueConvertible {
    init?(_ value: Value)
    
    var asValue: Value { get }
}

