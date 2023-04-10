import XCTest
@testable import MiniCAD

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
    
    func testPlaneNormal() {
        assertThat(Plane(a: Vec3(x: 2.6481), b: Vec3(y: 7.5410), c: Vec3(z: 1.7694)).unitNormal, approximatelyEquals: Vec3(x: -0.5453, y: -0.1915, z: -0.8161).normalized)
        assertThat(Plane(a: Vec3(x: -2.6481), b: Vec3(y: 7.5410), c: Vec3(z: 1.7694)).unitNormal, approximatelyEquals: Vec3(x: -0.5453, y: 0.1915, z: 0.8161).normalized)
        assertThat(Plane(a: Vec3(x: -1.7694), b: Vec3(y: 7.5410), c: Vec3(z: 2.6481)).unitNormal, approximatelyEquals: Vec3(x: -0.8161, y: 0.1915, z: 0.5453).normalized)
        assertThat(Plane(a: Vec3(x: -1.7694), b: Vec3(y: -7.5410), c: Vec3(z: 2.6481)).unitNormal, approximatelyEquals: Vec3(x: 0.8161, y: 0.1915, z: -0.5453).normalized)
        assertThat(Plane(a: Vec3(x: -2.6481), b: Vec3(y: -7.5410), c: Vec3(z: -1.7694)).unitNormal, approximatelyEquals: Vec3(x: -0.5453, y: -0.1915, z: -0.8161).normalized)
    }
    
    private func assertThat(_ a: Vec3, approximatelyEquals b: Vec3, line: UInt = #line) {
        XCTAssertEqual(a.x, b.x, accuracy: epsilon, line: line)
        XCTAssertEqual(a.y, b.y, accuracy: epsilon, line: line)
        XCTAssertEqual(a.z, b.z, accuracy: epsilon, line: line)
    }
}
