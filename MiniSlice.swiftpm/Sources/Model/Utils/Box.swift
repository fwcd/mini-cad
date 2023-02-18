@propertyWrapper
final class Box<Wrapped> {
    var wrappedValue: Wrapped
    
    init(wrappedValue: Wrapped) {
        self.wrappedValue = wrappedValue
    }
}

extension Box: Equatable where Wrapped: Equatable {
    static func ==(lhs: Box<Wrapped>, rhs: Box<Wrapped>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension Box: Hashable where Wrapped: Hashable {
    func hash(into hasher: inout Hasher) {
        wrappedValue.hash(into: &hasher)
    }
}
