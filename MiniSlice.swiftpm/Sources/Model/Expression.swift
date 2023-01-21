enum Expression: Hashable, CustomStringConvertible {
    case identifier(String)
    case call(String, [Expression])
    
    var description: String {
        switch self {
        case .identifier(let ident):
            return ident
        case .call(let name, let args):
            return "\(name)(\(args.map { "\($0)" }.joined(separator: ", "))"
        }
    }
}
