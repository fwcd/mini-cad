extension Int: ValueConvertible {
    init?(_ value: Value) {
        switch value {
        case .int(let x):
            self = x
        default:
            return nil
        }
    }
    
    var asValue: Value {
        .int(self)
    }
}
