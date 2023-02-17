/// A binary operator token.
enum BinaryOperator: Hashable, CustomStringConvertible {
    case multiply    // *
    case divide      // /
    case remainder   // %
    case add         // +
    case subtract    // -
    case toInclusive // ..<
    case toExclusive // ...
    case lessThan    // <
    case lessOrEqual // <=
    case greaterThan // >
    case greaterOrEqual // >=
    case equal       // ==
    case notEqual    // !=
    case logicalAnd  // &&
    case logicalOr   // ||
    
    // Operator precendences and associativies are inspired by Swift:
    // https://developer.apple.com/documentation/swift/operator-declarations
    
    /// This operator's precedence.
    var precedence: Int {
        switch self {
        case .multiply: return 10
        case .divide: return 10
        case .remainder: return 10
            
        case .add: return 9
        case .subtract: return 9
            
        case .toInclusive: return 8
        case .toExclusive: return 8
            
        case .lessThan: return 7
        case .lessOrEqual: return 7
        case .greaterThan: return 7
        case .greaterOrEqual: return 7
        case .equal: return 7
        case .notEqual: return 7
            
        case .logicalAnd: return 6
            
        case .logicalOr: return 5
        }
    }
    
    /// This operator's associativity.
    var associativity: Associativity {
        switch self {
        case .multiply: return .left
        case .divide: return .left
        case .remainder: return .left
            
        case .add: return .left
        case .subtract: return .left
            
        case .toInclusive: return .undefined
        case .toExclusive: return .undefined
            
        case .lessThan: return .undefined
        case .lessOrEqual: return .undefined
        case .greaterThan: return .undefined
        case .greaterOrEqual: return .undefined
        case .equal: return .undefined
        case .notEqual: return .undefined
            
        case .logicalAnd: return .left
            
        case .logicalOr: return .left
        }
    }
    
    var description: String {
        switch self {
        case .multiply: return "*"
        case .divide: return "/"
        case .remainder: return "%"
            
        case .add: return "+"
        case .subtract: return "-"
            
        case .toInclusive: return "..."
        case .toExclusive: return "..<"
            
        case .lessThan: return "<"
        case .lessOrEqual: return "<="
        case .greaterThan: return ">"
        case .greaterOrEqual: return ">="
        case .equal: return "=="
        case .notEqual: return "!="
            
        case .logicalAnd: return "&&"
            
        case .logicalOr: return "||"
        }
    }
    
    enum Associativity: Hashable {
        case left
        case right
        case undefined
    }
}
