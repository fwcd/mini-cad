import XCTest
@testable import MiniSlice

final class Vec3Tests: XCTestCase {
    func testAddition() {
        XCTAssertEqual(Vec3(x: 2) + Vec3(z: -2), Vec3(x: 2, y: 0, z: -2))
        XCTAssertEqual(Vec3(x: 9, y: -3, z: 1) + Vec3(x: 1, y: -1, z: -1), Vec3(x: 10, y: -4, z: 0))
    }
    
    func testSubtraction() {
        XCTAssertEqual(Vec3(x: 2) - Vec3(z: -2), Vec3(x: 2, y: 0, z: 2))
        XCTAssertEqual(Vec3(x: 9, y: -3, z: 1) - Vec3(x: 1, y: -1, z: -1), Vec3(x: 8, y: -2, z: 2))
    }
    
    func testScalarMultiplication() {
        XCTAssertEqual(3 * Vec3(x: 1, y: 2, z: 3), Vec3(x: 3, y: 6, z: 9))
        XCTAssertEqual(Vec3(x: 1, y: 2, z: 3) * 3, Vec3(x: 3, y: 6, z: 9))
    }
    
    func testDotProduct() {
        XCTAssertEqual(Vec3(x: 3, y: 4, z: 5).dot(Vec3(x: 9, y: 10, z: 11)), 122)
    }
    
    func testCrossProduct() {
        XCTAssertEqual(Vec3(x: 3, y: 4, z: 5).cross(Vec3(x: 9, y: 10, z: 11)), Vec3(x: -6, y: 12, z: -6))
    }
}