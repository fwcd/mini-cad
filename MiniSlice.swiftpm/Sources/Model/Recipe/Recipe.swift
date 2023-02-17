/// A recipe syntax tree.
struct Recipe: Hashable {
    var statements: [Statement] = []
}

extension Recipe: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Statement...) {
        self.init(statements: elements)
    }
}
