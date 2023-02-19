extension Double: ValueConvertible {
    init?(_ value: Value) {
        switch value {
        case .int(let x):
            self.init(x)
        case .float(let x):
            self = x
        default:
            return nil
        }
    }
    
    var asValue: Value {
        .float(self)
    }
}
