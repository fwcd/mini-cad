import Foundation

/// An identified function with identity-based equality semantics.
struct Function: Identifiable, Hashable {
    let id: UUID = UUID()
    let implementation: ([Value]) -> Value
    
    init(_ implementation: @escaping  ([Value]) -> Value) {
        self.implementation = implementation
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}
