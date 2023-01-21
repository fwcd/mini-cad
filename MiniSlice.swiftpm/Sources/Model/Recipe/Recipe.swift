struct Recipe: Hashable, CustomStringConvertible {
    var statements: [Statement] = []
    
    var description: String {
        statements.map { "\($0)" }.joined(separator: "\n")
    }
}
