/// A statement syntax tree.
enum Statement: Hashable, CustomStringConvertible {
    case varBinding(VarBinding)
    case expression(Expression)
    case forLoop(ForLoop)
    case blank
    
    var description: String {
        switch self {
        case let .varBinding(binding):
            return "\(binding)"
        case let .expression(expr):
            return "\(expr)"
        case let .forLoop(loop):
            return "\(loop)"
        case .blank:
            return ""
        }
    }
}
