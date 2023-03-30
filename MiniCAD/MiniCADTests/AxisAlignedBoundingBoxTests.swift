import XCTest
@testable import MiniCAD

final class AxisAlignedBoundingBoxTests: XCTestCase {
    func testOctants() {
        let aabb = AxisAlignedBoundingBox(corner: Vec3(all: -1), size: Vec3(all: 2))
        XCTAssertEqual(aabb.octants, [
            AxisAlignedBoundingBox(corner: Vec3(x: -1, y: -1, z: -1), size: Vec3(all: 1)),
            AxisAlignedBoundingBox(corner: Vec3(x: -1, y: -1, z:  0), size: Vec3(all: 1)),
            AxisAlignedBoundingBox(corner: Vec3(x: -1, y:  0, z: -1), size: Vec3(all: 1)),
            AxisAlignedBoundingBox(corner: Vec3(x: -1, y:  0, z:  0), size: Vec3(all: 1)),
            AxisAlignedBoundingBox(corner: Vec3(x:  0, y: -1, z: -1), size: Vec3(all: 1)),
            AxisAlignedBoundingBox(corner: Vec3(x:  0, y: -1, z:  0), size: Vec3(all: 1)),
            AxisAlignedBoundingBox(corner: Vec3(x:  0, y:  0, z: -1), size: Vec3(all: 1)),
            AxisAlignedBoundingBox(corner: Vec3(x:  0, y:  0, z:  0), size: Vec3(all: 1)),
        ])
    }
}
