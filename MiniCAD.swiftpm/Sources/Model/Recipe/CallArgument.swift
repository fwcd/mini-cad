/// The syntax-tree for a (function) call expression.
struct CallArgument<Attachment> {
    var label: String?
    var value: Expression<Attachment>
    
    func map<T>(_ transform: (Attachment) throws -> T) rethrows -> CallArgument<T> {
        CallArgument<T>(
            label: label,
            value: try value.map(transform)
        )
    }
}

extension CallArgument: Equatable where Attachment: Equatable {}

extension CallArgument: Hashable where Attachment: Hashable {}

extension CallArgument: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.init(value: .init(stringLiteral: value))
    }
}

extension CallArgument: ExpressibleByIntegerLiteral {
    init(integerLiteral value: Int) {
        self.init(value: .init(integerLiteral: value))
    }
}

extension CallArgument: ExpressibleByFloatLiteral {
    init(floatLiteral value: Double) {
        self.init(value: .init(floatLiteral: value))
    }
}
