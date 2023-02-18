struct BinaryExpression: Hashable {
    @Box var lhs: Expression
    var op: BinaryOperator
    @Box var rhs: Expression
}

// MARK: Convenience initializers

extension BinaryExpression {
    static func multiply(_ lhs: Expression, _ rhs: Expression) -> Self { .init(lhs: lhs, op: .multiply, rhs: rhs) }
    static func divide(_ lhs: Expression, _ rhs: Expression) -> Self { .init(lhs: lhs, op: .divide, rhs: rhs) }
    static func remainder(_ lhs: Expression, _ rhs: Expression) -> Self { .init(lhs: lhs, op: .remainder, rhs: rhs) }
    static func add(_ lhs: Expression, _ rhs: Expression) -> Self { .init(lhs: lhs, op: .add, rhs: rhs) }
    static func subtract(_ lhs: Expression, _ rhs: Expression) -> Self { .init(lhs: lhs, op: .subtract, rhs: rhs) }
    static func closedRange(_ lhs: Expression, _ rhs: Expression) -> Self { .init(lhs: lhs, op: .toInclusive, rhs: rhs) }
    static func range(_ lhs: Expression, _ rhs: Expression) -> Self { .init(lhs: lhs, op: .toExclusive, rhs: rhs) }
    static func lessOrEqual(_ lhs: Expression, _ rhs: Expression) -> Self { .init(lhs: lhs, op: .lessOrEqual, rhs: rhs) }
    static func lessThan(_ lhs: Expression, _ rhs: Expression) -> Self { .init(lhs: lhs, op: .lessThan, rhs: rhs) }
    static func greaterOrEqual(_ lhs: Expression, _ rhs: Expression) -> Self { .init(lhs: lhs, op: .greaterOrEqual, rhs: rhs) }
    static func greaterThan(_ lhs: Expression, _ rhs: Expression) -> Self { .init(lhs: lhs, op: .greaterThan, rhs: rhs) }
    static func equal(_ lhs: Expression, _ rhs: Expression) -> Self { .init(lhs: lhs, op: .equal, rhs: rhs) }
    static func notEqual(_ lhs: Expression, _ rhs: Expression) -> Self { .init(lhs: lhs, op: .notEqual, rhs: rhs) }
    static func logicalAnd(_ lhs: Expression, _ rhs: Expression) -> Self { .init(lhs: lhs, op: .logicalAnd, rhs: rhs) }
    static func logicalOr(_ lhs: Expression, _ rhs: Expression) -> Self { .init(lhs: lhs, op: .logicalOr, rhs: rhs) }
}
