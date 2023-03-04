import XCTest
@testable import MiniSlice

private let epsilon = 0.001

final class TriangleTests: XCTestCase {
    func testBarycentricConversion() {
        let triangle = Triangle(a: Vec3(x: 1), b: Vec3(y: 1), c: Vec3(z: 1))
        assertApproxEqual(triangle.toBarycentric(point: triangle.a), Vec3(x: 1))
        assertApproxEqual(triangle.toBarycentric(point: triangle.b), Vec3(y: 1))
        assertApproxEqual(triangle.toBarycentric(point: triangle.c), Vec3(z: 1))
    }
    
    private func assertApproxEqual(_ a: Vec3, _ b: Vec3, line: UInt = #line) {
        XCTAssertEqual(a.x, b.x, accuracy: epsilon, line: line)
        XCTAssertEqual(a.y, b.y, accuracy: epsilon, line: line)
        XCTAssertEqual(a.z, b.z, accuracy: epsilon, line: line)
    }
}
