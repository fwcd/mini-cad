/// A statement syntax tree.
enum Statement: Hashable {
    case varBinding(VarBinding)
    case expression(Expression)
    case forLoop(ForLoop)
    case blank
}
