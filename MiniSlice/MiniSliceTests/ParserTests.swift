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
    
    func testRangeExpressions() throws {
        let ops: [(String, (Expression, Expression) -> BinaryExpression)] = [
            ("..<", { .range($0, $1) }),
            ("...", { .closedRange($0, $1) })
        ]
        for (raw, makeBinaryExpr) in ops {
            try assert("0\(raw)0", parsesTo: [.expression(.binary(makeBinaryExpr(0, 0)))])
            try assert("0\(raw)2", parsesTo: [.expression(.binary(makeBinaryExpr(0, 2)))])
            try assert("-9\(raw)4", parsesTo: [.expression(.binary(makeBinaryExpr(-9, 4)))])
            try assert("b\(raw)c", parsesTo: [.expression(.binary(makeBinaryExpr("b", "c")))])
            // try assert("a\(raw)-2.3", parsesTo: [.expression(.binary(op("a", -2.3)))])
        }
    }
    
    func testBinaryExpressions() throws {
        let ops: [(String, (Expression, Expression) -> BinaryExpression)] = [
            ("+", { .add($0, $1) }),
            ("-", { .subtract($0, $1) })
        ]
        for (raw, makeBinaryExpr) in ops {
            try assert("0 \(raw) 0", parsesTo: [.expression(.binary(makeBinaryExpr(0, 0)))])
            try assert("91 \(raw) 34", parsesTo: [.expression(.binary(makeBinaryExpr(91, 34)))])
        }
        
        try assert("3 + 5 - 9", parsesTo: [.expression(.binary(.subtract(.binary(.add(3, 5)), 9)))])
        try assert("9 - 1 - 3", parsesTo: [.expression(.binary(.subtract(.binary(.subtract(9, 1)), 3)))])
    }
    
    func testBindings() throws {
        try assert("let x = 3", parsesTo: [.varBinding(.init(name: "x", value: .literal(.int(3))))])
        try assert("let abc = -9.87", parsesTo: [.varBinding(.init(name: "abc", value: .literal(.float(-9.87))))])
        try assert("let name =", throws: .expected(.assign, actual: nil))
        try assert("let name =\n", throws: .expectedExpression(actual: nil))
    }
    
    func testForLoops() throws {
        try assert("for i in 0..<4 {}", parsesTo: [.forLoop(.init(name: "i", sequence: .binary(.range(0, 4))))])
    }
    
    func testFullPrograms() throws {
        try assert("""
            let w = 3
            let h = 4

            for i in 0..<w {
              for j in 0..<h {
                Translate(i, i, j) {
                  Cuboid()
                }
              }
            }
        """, parsesTo: [
            .varBinding(.init(name: "w", value: 3)),
            .varBinding(.init(name: "h", value: 4)),
            .blank,
            .forLoop(.init(name: "i", sequence: .binary(.range(0, "w")), block: [
                .forLoop(.init(name: "j", sequence: .binary(.range(0, "h")), block: [
                    .expression(.call(.init(identifier: "Translate", args: ["i", "i", "j"], trailingBlock: [
                        .expression(.call("Cuboid"))
                    ]))),
                ])),
            ])),
        ])
    }
    
    private func assert(_ raw: String, parsesTo recipe: Recipe<Void>, line: UInt = #line) throws {
        XCTAssertEqual(try parseRecipe(from: raw).map { _ in HashableVoid() }, recipe.map { _ in HashableVoid() }, line: line)
    }
    
    private func assert(_ raw: String, throws expectedError: ParseError, line: UInt = #line) throws {
        do {
            _ = try parseRecipe(from: raw)
            XCTFail("'\(raw)' did not error with \(expectedError)", line: line)
        } catch let error as ParseError {
            if error != expectedError {
                XCTFail("'\(raw)' did not error with \(expectedError), but \(error)", line: line)
            }
        } catch {
            XCTFail("'\(raw)' did not error with \(expectedError), but with unrelated \(error)", line: line)
        }
    }
}
