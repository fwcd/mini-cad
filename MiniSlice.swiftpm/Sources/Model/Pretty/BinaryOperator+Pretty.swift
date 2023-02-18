extension BinaryOperator {
    func pretty(formatter: Formatter = .init()) -> String {
        switch self {
        case .multiply: return "*"
        case .divide: return "/"
        case .remainder: return "%"
            
        case .add: return "+"
        case .subtract: return "-"
            
        case .toInclusive: return "..."
        case .toExclusive: return "..<"
            
        case .lessOrEqual: return "<="
        case .lessThan: return "<"
        case .greaterOrEqual: return ">="
        case .greaterThan: return ">"
        case .equal: return "=="
        case .notEqual: return "!="
            
        case .logicalAnd: return "&&"
            
        case .logicalOr: return "||"
        }
    }
}
