import XCTest
@testable import MiniSlice

private let epsilon = 0.001

final class PlaneTests: XCTestCase {
    func testPlaneLineIntersection() {
        let plane = Plane(a: Vec3(x: 1), b: Vec3(y: 1), c: Vec3(z: 1))
        let line = Line(a: Vec3(all: -1), b: Vec3(all: 2))
        let intersection = plane.intersection(line)
        XCTAssertEqual(intersection.x, 1 / 3, accuracy: epsilon)
        XCTAssertEqual(intersection.y, 1 / 3, accuracy: epsilon)
        XCTAssertEqual(intersection.z, 1 / 3, accuracy: epsilon)
    }
    
    func testPlanePointProjection() {
        let plane = Plane(a: Vec3(x: 1), b: Vec3(y: 1), c: Vec3(z: 1))
        let point = plane.project(.zero)
        XCTAssertEqual(point.x, 1 / 3, accuracy: epsilon)
        XCTAssertEqual(point.y, 1 / 3, accuracy: epsilon)
        XCTAssertEqual(point.z, 1 / 3, accuracy: epsilon)
    }
}
