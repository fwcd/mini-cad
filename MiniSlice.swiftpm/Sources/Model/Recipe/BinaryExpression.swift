struct BinaryExpression: Hashable {
    @Box var lhs: Expression
    var op: BinaryOperator
    @Box var rhs: Expression
}
