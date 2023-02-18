@propertyWrapper
class Box<Wrapped> {
    var wrappedValue: Wrapped
    
    init(wrappedValue: Wrapped) {
        self.wrappedValue = wrappedValue
    }
}
