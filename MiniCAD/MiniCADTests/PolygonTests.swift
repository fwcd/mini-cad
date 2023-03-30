import XCTest
@testable import MiniCAD

final class PolygonTests: XCTestCase {
    func testTriangulation() {
        let vertices = [
            Vec3(x: 0, y: 0),
            Vec3(x: 7, y: 0),
            Vec3(x: 4, y: 1),
            Vec3(x: 2, y: 2),
            Vec3(x: 1, y: 4),
            Vec3(x: 0, y: 7),
        ]
        let polygon = Polygon(vertices: vertices)
        XCTAssertEqual(Mesh(polygon).faces, [
            Mesh.Face(a: 0, b: 1, c: 2),
            Mesh.Face(a: 0, b: 2, c: 3),
            Mesh.Face(a: 0, b: 3, c: 4),
            Mesh.Face(a: 0, b: 4, c: 5),
        ])
    }
}
