/// The syntax tree for an if/else statement.
struct IfElse<Attachment> {
    var condition: Expression<Attachment>
    var ifBlock: [Statement<Attachment>] = []
    var elseBlock: [Statement<Attachment>]? = nil
    var attachment: Attachment
    
    func map<T>(_ transform: (Attachment) throws -> T) rethrows -> IfElse<T> {
        IfElse<T>(
            condition: try condition.map(transform),
            ifBlock: try ifBlock.map { try $0.map(transform) },
            elseBlock: try elseBlock?.map { try $0.map(transform) },
            attachment: try transform(attachment)
        )
    }
}

extension IfElse: Equatable where Attachment: Equatable {}

extension IfElse: Hashable where Attachment: Hashable {}

extension IfElse where Attachment == Void {
    init(condition: Expression<Attachment>, ifBlock: [Statement<Attachment>] = [], elseBlock: [Statement<Attachment>]? = nil) {
        self.init(condition: condition, ifBlock: ifBlock, elseBlock: elseBlock, attachment: ())
    }
}
