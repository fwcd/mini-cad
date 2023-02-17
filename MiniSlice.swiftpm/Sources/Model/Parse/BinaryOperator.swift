enum BinaryOperator: Hashable {
    case toInclusive // ..<
    case toExclusive // ...
    
    // Operator precendences and associativies are inspired by Swift:
    // https://developer.apple.com/documentation/swift/operator-declarations
    
    /// This operator's precedence.
    var precedence: Int {
        switch self {
        case .toInclusive: return 3
        case .toExclusive: return 3
        }
    }
    
    /// This operator's associativity.
    var associativity: Associativity {
        switch self {
        case .toInclusive: return .undefined
        case .toExclusive: return .undefined
        }
    }
    
    enum Associativity: Hashable {
        case left
        case right
        case undefined
    }
}
