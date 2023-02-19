/// A recipe syntax tree.
struct Recipe: Hashable {
    var statements: [Ranged<Statement>] = []
}

extension Recipe: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Ranged<Statement>...) {
        self.init(statements: elements)
    }
}
