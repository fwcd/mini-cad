import Foundation

/// A lexical token. Before parsing the program/recipe is preprocessed into a sequence of tokens.
struct Token: Hashable {
    var kind: Kind
    
    // TODO: Investigate whether we could just express tokens as `Ranged<Token.Kind>` or similar?
    
    var sourceRange: SourceRange
    
    enum Kind: Hashable {
        case `let`
        case `for`
        case `in`
        case `if`
        case `else`
        case `func`
        case binaryOperator(BinaryOperator)
        case assign
        case newline
        case leftParen
        case rightParen
        case leftCurly
        case rightCurly
        case comma
        case float(String)
        case int(String)
        case identifier(String)
        case comment
        case string(String)
        case colon
        
        var isKeyword: Bool {
            switch self {
            case .let, .for, .in, .if, .else, .func: return true
            default: return false
            }
        }
        
        var isComment: Bool {
            self == .comment
        }
        
        var isString: Bool {
            switch self {
            case .string(_): return true
            default: return false
            }
        }
    }
}

