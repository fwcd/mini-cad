import XCTest
@testable import MiniCAD

final class TokenizerTests: XCTestCase {
    func testEmpty() throws {
        try assert("", tokenizesTo: [])
    }
    
    func testIdentifiers() throws {
        try assert("abc", tokenizesTo: [.identifier("abc")])
        try assert("a bc d", tokenizesTo: [.identifier("a"), .identifier("bc"), .identifier("d")])
    }
    
    func testNumericLiterals() throws {
        try assert("2", tokenizesTo: [.int("2")])
        try assert("2.5", tokenizesTo: [.float("2.5")])
        try assert("-0.1", tokenizesTo: [.float("-0.1")])
        try assert("-98", tokenizesTo: [.int("-98")])
    }
    
    func testBinaryOperators() throws {
        for op in BinaryOperator.allCases {
            try assert(op.pretty(), tokenizesTo: [.binaryOperator(op)])
        }
    }
    
    func testPrefixOperators() throws {
        for op in PrefixOperator.allCases where op != .negation {
            try assert(op.pretty(), tokenizesTo: [.prefixOperator(op)])
        }
    }
    
    private func assert(_ raw: String, tokenizesTo tokens: [Token.Kind], line: UInt = #line) throws {
        XCTAssertEqual(tokenize(raw).map(\.kind), tokens, line: line)
    }
}
