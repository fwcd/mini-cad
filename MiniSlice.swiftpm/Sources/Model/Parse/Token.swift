import Foundation

/// A lexical token. Before parsing the program/recipe is preprocessed into a sequence of tokens.
struct Token: Hashable {
    var kind: Kind
    
    var range: Range<String.Index>
    var nsRange: NSRange // We store the NSRange too to avoid costly index conversions during NSAttributedString construction
    
    enum Kind: Hashable {
        case `let`
        case `for`
        case `in`
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
        
        var isKeyword: Bool {
            switch self {
            case .let, .for, .in: return true
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

