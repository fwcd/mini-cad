import XCTest
@testable import MiniSlice

final class ValueTests: XCTestCase {
    func testConversions() {
        XCTAssertEqual(Value(4), .int(4))
        XCTAssertEqual(Value(4.3), .float(4.3))
        XCTAssertEqual(Value("abc"), .string("abc"))
        XCTAssertEqual(Value(true), .bool(true))
        XCTAssertEqual(Int(Value.int(4)), 4)
        XCTAssertEqual(Double(Value.float(4.3)), 4.3)
        XCTAssertEqual(String(Value.string("abc")), "abc")
        XCTAssertEqual(Bool(Value.bool(true)), true)
        XCTAssertEqual(Value(0..<3), .intRange(0..<3))
        XCTAssertEqual(Value(0.3..<3.9), .floatRange(0.3..<3.9))
        XCTAssertEqual(Value(0.3...3.9), .closedFloatRange(0.3...3.9))
        XCTAssertEqual(ClosedRange<Int>(Value.closedIntRange(-3...9)), -3...9)
        XCTAssertEqual(ClosedRange<Double>(Value.closedFloatRange(0.3...3.9)), 0.3...3.9)
    }
}
