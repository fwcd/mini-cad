struct Recipe: Hashable, CustomStringConvertible {
    var statements: [Statement] = []
    
    // TODO: Add separate format method and pass indent
    var description: String {
        statements.map { "\($0)" }.joined(separator: "\n")
    }
}
