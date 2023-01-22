/// A statement syntax tree.
enum Statement: Hashable, CustomStringConvertible {
    case varBinding(VarBinding)
    case expression(Expression)
    case blank
    
    var description: String {
        switch self {
        case .varBinding(let binding):
            return "\(binding)"
        case .expression(let expr):
            return "\(expr)"
        case .blank:
            return ""
        }
    }
}
