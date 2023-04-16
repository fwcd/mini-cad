import XCTest
@testable import MiniCAD

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
    
    func testPrefixExpression() throws {
        try assert("!true", parsesTo: [.expression(.prefix(.logicalNot(true)))])
        try assert("!!false", parsesTo: [.expression(.prefix(.logicalNot(.prefix(.logicalNot(false)))))])
        try assert("-9", parsesTo: [.expression(-9)])
        try assert("--9", parsesTo: [.expression(.prefix(.negation(-9)))])
        try assert("!--9", parsesTo: [.expression(.prefix(.logicalNot(.prefix(.negation(-9)))))])
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
    
    func testFuncDeclarations() throws {
        try assert("func test() {}", parsesTo: [.funcDeclaration(.init(name: "test"))])
        try assert("func identity(x) { x }", parsesTo: [.funcDeclaration(.init(name: "identity", paramNames: ["x"], block: [.expression("x")]))])
    }
    
    func testIfElse() throws {
        try assert("if x { x }", parsesTo: [.ifElse(.init(condition: "x", ifBlock: [.expression("x")]))])
        try assert("if true { x }", parsesTo: [.ifElse(.init(condition: true, ifBlock: [.expression("x")]))])
        try assert("""
            if false && true {
                x
            } else {
                test()
            }
        """, parsesTo: [
            .ifElse(.init(condition: .binary(.logicalAnd(false, true)), ifBlock: [
                .expression("x"),
            ], elseBlock: [
                .expression(.call("test")),
            ])),
        ])
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
        
            func noArgs() {}
        
            func oneArg(arg) {
              hello()
            }
            
            func twoArgs(x, y) {
              x + y
              func nested() {}
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
            .blank,
            .funcDeclaration(.init(name: "noArgs")),
            .blank,
            .funcDeclaration(.init(name: "oneArg", paramNames: ["arg"], block: [
                .expression(.call("hello")),
            ])),
            .blank,
            .funcDeclaration(.init(name: "twoArgs", paramNames: ["x", "y"], block: [
                .expression(.binary(.add("x", "y"))),
                .funcDeclaration(.init(name: "nested")),
            ])),
        ])
    }
    
    func testArgumentLabels() throws {
        try assert(#"test(foo: 23, bar: "abc", -9)"#, parsesTo: [
            .expression(.call(.init(identifier: "test", args: [
                .init(label: "foo", value: 23),
                .init(label: "bar", value: .literal(.string("abc"))),
                -9,
            ], trailingBlock: []))),
        ])
    }
    
    private func assert(_ raw: String, parsesTo recipe: Recipe<Void>, debugDump: Bool = false, line: UInt = #line) throws {
        let actual = try parseRecipe(from: raw).map { _ in HashableVoid() }
        let expected = recipe.map { _ in HashableVoid() }
        if debugDump {
            dump(expected)
            dump(actual)
        }
        XCTAssertEqual(expected, actual, line: line)
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
