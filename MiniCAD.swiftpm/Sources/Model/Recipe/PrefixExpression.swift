struct PrefixExpression<Attachment> {
    var op: PrefixOperator
    @Box var rhs: Expression<Attachment>
    var attachment: Attachment
    
    func map<T>(_ transform: (Attachment) throws -> T) rethrows -> PrefixExpression<T> {
        PrefixExpression<T>(
            op: op,
            rhs: try rhs.map(transform),
            attachment: try transform(attachment)
        )
    }
}

extension PrefixExpression: Equatable where Attachment: Equatable {}

extension PrefixExpression: Hashable where Attachment: Hashable {}

// MARK: Convenience initializers

extension PrefixExpression where Attachment == Void {
    init(op: PrefixOperator, rhs: Expression<Void>) {
        self.init(op: op, rhs: rhs, attachment: ())
    }
    
    static func logicalNot(_ rhs: Expression<Void>) -> Self { .init(op: .logicalNot, rhs: rhs) }
    static func negation(_ rhs: Expression<Void>) -> Self { .init(op: .negation, rhs: rhs) }
}
