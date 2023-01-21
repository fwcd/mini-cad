struct VarBinding: Hashable, CustomStringConvertible {
    let name: String
    let value: Expression
    
    var description: String {
        "let \(name) = \(value)"
    }
}
