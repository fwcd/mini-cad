import XCTest
@testable import MiniSlice

final class ParserTests: XCTestCase {
    func testEmpty() throws {
        try assert("", parsesTo: [])
    }
    
    func testNumericLiterals() throws {
        try assert("2", parsesTo: [.expression(.literal(.int(2)))])
        try assert("512", parsesTo: [.expression(.literal(.int(512)))])
        try assert("512.2", parsesTo: [.expression(.literal(.float(512.2)))])
        try assert("-21", parsesTo: [.expression(.literal(.int(-21)))])
        try assert("-21.4", parsesTo: [.expression(.literal(.float(-21.4)))])
    }
    
    private func assert(_ raw: String, parsesTo recipe: Recipe, line: UInt = #line) throws {
        XCTAssertEqual(try parseRecipe(from: raw), recipe, line: line)
    }
    
    private func assert(_ raw: String, throws expectedError: ParseError, line: UInt = #line) throws {
        do {
            _ = try parseRecipe(from: raw)
            XCTFail("'\(raw)' did not error with \(expectedError)")
        } catch let error as ParseError {
            if error != expectedError {
                XCTFail("'\(raw)' did not error with \(expectedError), but \(error)")
            }
        } catch {
            XCTFail("'\(raw)' did not error with \(expectedError), but with unrelated \(error)")
        }
    }
}
