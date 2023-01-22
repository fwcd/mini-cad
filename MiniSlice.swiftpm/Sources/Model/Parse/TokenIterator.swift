/// A peekable iterator over a sequence of tokens with a few convenience functions that are useful for parsing.
struct TokenIterator: IteratorProtocol {
    private var iterator: Array<Token>.Iterator
    private var peeked: Token? = nil
    
    /// The token returned by the most recent `.next()` call.
    private(set) var current: Token? = nil
    
    /// Whether the iterator has not reached the end yet.
    var hasNext: Bool {
        mutating get { peek() != nil }
    }
    
    init(_ tokens: [Token]) {
        iterator = tokens.makeIterator()
    }
    
    /// Consumes the next token and throws an error if it doesn't match the given token.
    mutating func expect(_ token: Token) throws {
        let actual = next()
        guard actual == token else {
            throw ParseError.expected(token, actual: actual)
        }
    }
    
    /// Consumes the next token if it matches the given token.
    mutating func skip(_ token: Token) {
        if peek() == token {
            next()
        }
    }
    
    /// Consumes the next token while it matches the given token.
    mutating func skipAll(_ token: Token) {
        while peek() == token {
            next()
        }
    }
    
    /// Peeks the next token without advancing the iteration.
    mutating func peek() -> Token? {
        if let peeked = peeked {
            return peeked
        } else {
            let peeked = iterator.next()
            self.peeked = peeked
            return peeked
        }
    }
    
    /// Consumes and returns the next token.
    @discardableResult
    mutating func next() -> Token? {
        if let peeked = peeked {
            self.peeked = nil
            current = peeked
        } else {
            current = iterator.next()
        }
        return current
    }
}
