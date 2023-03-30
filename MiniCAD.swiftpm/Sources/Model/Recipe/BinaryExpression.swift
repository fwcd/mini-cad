struct BinaryExpression<Attachment> {
    @Box var lhs: Expression<Attachment>
    var op: BinaryOperator
    @Box var rhs: Expression<Attachment>
    var attachment: Attachment
    
    func map<T>(_ transform: (Attachment) throws -> T) rethrows -> BinaryExpression<T> {
        BinaryExpression<T>(
            lhs: try lhs.map(transform),
            op: op,
            rhs: try rhs.map(transform),
            attachment: try transform(attachment)
        )
    }
}

extension BinaryExpression: Equatable where Attachment: Equatable {}

extension BinaryExpression: Hashable where Attachment: Hashable {}

// MARK: Convenience initializers

extension BinaryExpression where Attachment == Void {
    init(lhs: Expression<Void>, op: BinaryOperator, rhs: Expression<Void>) {
        self.init(lhs: lhs, op: op, rhs: rhs, attachment: ())
    }
    
    static func multiply(_ lhs: Expression<Void>, _ rhs: Expression<Void>) -> Self { .init(lhs: lhs, op: .multiply, rhs: rhs) }
    static func divide(_ lhs: Expression<Void>, _ rhs: Expression<Void>) -> Self { .init(lhs: lhs, op: .divide, rhs: rhs) }
    static func remainder(_ lhs: Expression<Void>, _ rhs: Expression<Void>) -> Self { .init(lhs: lhs, op: .remainder, rhs: rhs) }
    static func add(_ lhs: Expression<Void>, _ rhs: Expression<Void>) -> Self { .init(lhs: lhs, op: .add, rhs: rhs) }
    static func subtract(_ lhs: Expression<Void>, _ rhs: Expression<Void>) -> Self { .init(lhs: lhs, op: .subtract, rhs: rhs) }
    static func closedRange(_ lhs: Expression<Void>, _ rhs: Expression<Void>) -> Self { .init(lhs: lhs, op: .toInclusive, rhs: rhs) }
    static func range(_ lhs: Expression<Void>, _ rhs: Expression<Void>) -> Self { .init(lhs: lhs, op: .toExclusive, rhs: rhs) }
    static func lessOrEqual(_ lhs: Expression<Void>, _ rhs: Expression<Void>) -> Self { .init(lhs: lhs, op: .lessOrEqual, rhs: rhs) }
    static func lessThan(_ lhs: Expression<Void>, _ rhs: Expression<Void>) -> Self { .init(lhs: lhs, op: .lessThan, rhs: rhs) }
    static func greaterOrEqual(_ lhs: Expression<Void>, _ rhs: Expression<Void>) -> Self { .init(lhs: lhs, op: .greaterOrEqual, rhs: rhs) }
    static func greaterThan(_ lhs: Expression<Void>, _ rhs: Expression<Void>) -> Self { .init(lhs: lhs, op: .greaterThan, rhs: rhs) }
    static func equal(_ lhs: Expression<Void>, _ rhs: Expression<Void>) -> Self { .init(lhs: lhs, op: .equal, rhs: rhs) }
    static func notEqual(_ lhs: Expression<Void>, _ rhs: Expression<Void>) -> Self { .init(lhs: lhs, op: .notEqual, rhs: rhs) }
    static func logicalAnd(_ lhs: Expression<Void>, _ rhs: Expression<Void>) -> Self { .init(lhs: lhs, op: .logicalAnd, rhs: rhs) }
    static func logicalOr(_ lhs: Expression<Void>, _ rhs: Expression<Void>) -> Self { .init(lhs: lhs, op: .logicalOr, rhs: rhs) }
}
