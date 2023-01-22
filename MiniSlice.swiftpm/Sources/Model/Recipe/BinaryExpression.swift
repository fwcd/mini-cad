/// The syntax-tree for a 2-ary infix operator expression.
indirect enum BinaryExpression: Hashable {
    case range(Expression, Expression)
    case closedRange(Expression, Expression)
}
