extension String: ValueConvertible {
    init?(_ value: Value) {
        switch value {
        case .string(let x):
            self = x
        default:
            return nil
        }
    }
    
    var asValue: Value {
        .string(self)
    }
}
