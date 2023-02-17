import XCTest
@testable import MiniSlice

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
            try assert("\(op)", tokenizesTo: [.binaryOperator(op)])
        }
    }
    
    private func assert(_ raw: String, tokenizesTo tokens: [Token], line: UInt = #line) throws {
        XCTAssertEqual(tokenize(raw), tokens, line: line)
    }
}
