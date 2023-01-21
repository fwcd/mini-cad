struct TokenIterator: IteratorProtocol {
    private var iterator: Array<Token>.Iterator
    private var peeked: Token? = nil
    
    var hasNext: Bool {
        mutating get { peek() != nil }
    }
    
    init(_ tokens: [Token]) {
        iterator = tokens.makeIterator()
    }
    
    mutating func expect(_ token: Token) throws {
        guard next() == token else {
            throw ParseError.expected([token])
        }
    }
    
    mutating func skip(_ token: Token) {
        if peek() == token {
            next()
        }
    }
    
    mutating func peek() -> Token? {
        if let peeked = peeked {
            return peeked
        } else {
            let peeked = iterator.next()
            self.peeked = peeked
            return peeked
        }
    }
    
    @discardableResult
    mutating func next() -> Token? {
        if let peeked = peeked {
            self.peeked = nil
            return peeked
        } else {
            return iterator.next()
        }
    }
}
