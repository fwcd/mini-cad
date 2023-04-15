/// The syntax tree for a function declaration.
struct FuncDeclaration<Attachment> {
    var name: String
    var paramNames: [String] = []
    var block: [Statement<Attachment>] = []
    var attachment: Attachment
    
    func map<T>(_ transform: (Attachment) throws -> T) rethrows -> FuncDeclaration<T> {
        FuncDeclaration<T>(
            name: name,
            paramNames: paramNames,
            block: try block.map { try $0.map(transform) },
            attachment: try transform(attachment)
        )
    }
}

extension FuncDeclaration: Equatable where Attachment: Equatable {}

extension FuncDeclaration: Hashable where Attachment: Hashable {}

extension FuncDeclaration where Attachment == Void {
    init(name: String, paramNames: [String] = [], block: [Statement<Attachment>] = []) {
        self.init(name: name, paramNames: paramNames, block: block, attachment: ())
    }
}
