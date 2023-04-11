/// The syntax-tree for a (function) call expression.
struct CallExpression<Attachment> {
    var identifier: String
    var args: [CallArgument<Attachment>] = []
    var trailingBlock: [Statement<Attachment>] = []
    var attachment: Attachment
    
    func map<T>(_ transform: (Attachment) throws -> T) rethrows -> CallExpression<T> {
        CallExpression<T>(
            identifier: identifier,
            args: try args.map { try $0.map(transform) },
            trailingBlock: try trailingBlock.map { try $0.map(transform) },
            attachment: try transform(attachment)
        )
    }
}

extension CallExpression: Equatable where Attachment: Equatable {}

extension CallExpression: Hashable where Attachment: Hashable {}

extension CallExpression: ExpressibleByUnicodeScalarLiteral where Attachment == Void {}

extension CallExpression: ExpressibleByExtendedGraphemeClusterLiteral where Attachment == Void {}

extension CallExpression: ExpressibleByStringLiteral where Attachment == Void {
    init(stringLiteral value: String) {
        self.init(identifier: value, attachment: ())
    }
}

extension CallExpression where Attachment == Void {
    init(identifier: String, args: [CallArgument<Void>], trailingBlock: [Statement<Void>]) {
        self.init(identifier: identifier, args: args, trailingBlock: trailingBlock, attachment: ())
    }
}

