/// A statement syntax tree.
enum Statement<Attachment> {
    case varBinding(VarBinding<Attachment>)
    case expression(Expression<Attachment>)
    case forLoop(ForLoop<Attachment>)
    case ifElse(IfElse<Attachment>)
    case funcDeclaration(FuncDeclaration<Attachment>)
    case blank
    
    func map<T>(_ transform: (Attachment) throws -> T) rethrows -> Statement<T> {
        switch self {
        case .varBinding(let varBinding):
            return .varBinding(try varBinding.map(transform))
        case .expression(let expression):
            return .expression(try expression.map(transform))
        case .forLoop(let forLoop):
            return .forLoop(try forLoop.map(transform))
        case .ifElse(let ifElse):
            return .ifElse(try ifElse.map(transform))
        case .funcDeclaration(let decl):
            return .funcDeclaration(try decl.map(transform))
        case .blank:
            return .blank
        }
    }
}

extension Statement: Equatable where Attachment: Equatable {}

extension Statement: Hashable where Attachment: Hashable {}
