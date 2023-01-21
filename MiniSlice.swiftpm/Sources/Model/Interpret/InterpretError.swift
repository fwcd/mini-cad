enum InterpretError: Error, CustomStringConvertible {
    case variableNotInScope(String)
    case functionNotInScope(String)
    
    var description: String {
        switch self {
        case .variableNotInScope(let name):
            return "The variable \(name) is not in scope"
        case .functionNotInScope(let name):
            return "The function \(name) is not in scope"
        }
    }
}
