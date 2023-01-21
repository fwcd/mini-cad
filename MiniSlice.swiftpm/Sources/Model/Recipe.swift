struct Recipe: Hashable, CustomStringConvertible {
    let statements: [Statement]
    
    var description: String {
        statements.map { "\($0)" }.joined(separator: "\n")
    }
}
