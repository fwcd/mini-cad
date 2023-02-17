/// The syntax-tree for a (function) call expression.
struct CallExpression: Hashable {
    var identifier: String
    var args: [Expression] = []
    var trailingBlock: [Statement] = []
}

extension CallExpression: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.init(identifier: value)
    }
}
