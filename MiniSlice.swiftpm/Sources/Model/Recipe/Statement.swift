/// A statement syntax tree.
enum Statement: Hashable, CustomStringConvertible {
    case varBinding(VarBinding)
    case expression(Expression)
    case forLoop(String, Expression, [Statement])
    case blank
    
    var description: String {
        switch self {
        case let .varBinding(binding):
            return "\(binding)"
        case let .expression(expr):
            return "\(expr)"
        case let .forLoop(name, sequence, block):
            return (["for \(name) in \(sequence) {"] + block.map { "\($0)" } + ["}"]).joined(separator: "\n")
        case .blank:
            return ""
        }
    }
}
