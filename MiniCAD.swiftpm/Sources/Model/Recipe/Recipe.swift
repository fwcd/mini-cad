/// A recipe syntax tree.
struct Recipe<Attachment> {
    var statements: [Statement<Attachment>] = []
    
    func map<T>(_ transform: (Attachment) throws -> T) rethrows -> Recipe<T> {
        Recipe<T>(
            statements: try statements.map { try $0.map(transform) }
        )
    }
}

extension Recipe: Equatable where Attachment: Equatable {}

extension Recipe: Hashable where Attachment: Hashable {}

extension Recipe: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Statement<Attachment>...) {
        self.init(statements: elements)
    }
}
