/// The syntax-tree for a 2-ary infix operator expression.
indirect enum BinaryExpression: Hashable {
    // TODO: Investigate whether we should make this a struct with boxed expressions (lhs and rhs) and a BinaryOperator
    
    case add(Expression, Expression)
    case subtract(Expression, Expression)
    case range(Expression, Expression)
    case closedRange(Expression, Expression)
}
