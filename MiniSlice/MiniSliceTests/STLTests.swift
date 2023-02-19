import XCTest
@testable import MiniSlice

final class STLTests: XCTestCase {
    func testCuboidSTL() {
        print(Mesh(Cuboid()).asSTL)
    }
}
