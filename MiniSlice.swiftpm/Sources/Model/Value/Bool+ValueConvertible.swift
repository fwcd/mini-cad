extension Bool: ValueConvertible {
    init?(_ value: Value) {
        switch value {
        case .bool(let x):
            self = x
        default:
            return nil
        }
    }
    
    var asValue: Value {
        .bool(self)
    }
}
