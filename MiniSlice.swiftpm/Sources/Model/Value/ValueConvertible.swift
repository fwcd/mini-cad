/// Conformance indicates that the type is convertible to and from `Value`.
protocol ValueConvertible {
    init?(_ value: Value)
    
    var asValue: Value { get }
}

extension Value {
    init<T>(_ x: T) where T: ValueConvertible {
        self = x.asValue
    }
}

extension Value: ValueConvertible {
    init?(_ value: Value) {
        self = value
    }
    
    var asValue: Value {
        self
    }
}
