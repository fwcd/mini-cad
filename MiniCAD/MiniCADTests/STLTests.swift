import XCTest
@testable import MiniCAD

final class STLTests: XCTestCase {
    func testCuboidSTL() {
        // We're comparing floating-points for exact equality here, but since floating-point arithmetic should be deterministic, this is still a quick and useful way to pin down the resulting STL and make sure that we are not regressing on anything
        XCTAssertEqual(Mesh(Cuboid()).asAsciiStl, """
            solid mesh
                facet normal 1.0 -0.0 0.0
                    outer loop
                        vertex -0.5 -0.5 -0.5
                        vertex -0.5 -0.5 0.5
                        vertex -0.5 0.5 0.5
                    endloop
                endfacet
                facet normal 1.0 0.0 0.0
                    outer loop
                        vertex -0.5 -0.5 -0.5
                        vertex -0.5 0.5 0.5
                        vertex -0.5 0.5 -0.5
                    endloop
                endfacet
                facet normal -1.0 -0.0 -0.0
                    outer loop
                        vertex 0.5 0.5 -0.5
                        vertex 0.5 0.5 0.5
                        vertex 0.5 -0.5 0.5
                    endloop
                endfacet
                facet normal -1.0 0.0 0.0
                    outer loop
                        vertex 0.5 0.5 -0.5
                        vertex 0.5 -0.5 0.5
                        vertex 0.5 -0.5 -0.5
                    endloop
                endfacet
                facet normal 0.0 1.0 0.0
                    outer loop
                        vertex 0.5 -0.5 -0.5
                        vertex 0.5 -0.5 0.5
                        vertex -0.5 -0.5 0.5
                    endloop
                endfacet
                facet normal 0.0 1.0 0.0
                    outer loop
                        vertex 0.5 -0.5 -0.5
                        vertex -0.5 -0.5 0.5
                        vertex -0.5 -0.5 -0.5
                    endloop
                endfacet
                facet normal 0.0 -1.0 0.0
                    outer loop
                        vertex -0.5 0.5 -0.5
                        vertex -0.5 0.5 0.5
                        vertex 0.5 0.5 0.5
                    endloop
                endfacet
                facet normal 0.0 -1.0 -0.0
                    outer loop
                        vertex -0.5 0.5 -0.5
                        vertex 0.5 0.5 0.5
                        vertex 0.5 0.5 -0.5
                    endloop
                endfacet
                facet normal 0.0 -0.0 1.0
                    outer loop
                        vertex 0.5 0.5 -0.5
                        vertex 0.5 -0.5 -0.5
                        vertex -0.5 -0.5 -0.5
                    endloop
                endfacet
                facet normal 0.0 0.0 1.0
                    outer loop
                        vertex 0.5 0.5 -0.5
                        vertex -0.5 -0.5 -0.5
                        vertex -0.5 0.5 -0.5
                    endloop
                endfacet
                facet normal -0.0 -0.0 -1.0
                    outer loop
                        vertex 0.5 -0.5 0.5
                        vertex 0.5 0.5 0.5
                        vertex -0.5 0.5 0.5
                    endloop
                endfacet
                facet normal 0.0 0.0 -1.0
                    outer loop
                        vertex 0.5 -0.5 0.5
                        vertex -0.5 0.5 0.5
                        vertex -0.5 -0.5 0.5
                    endloop
                endfacet
            endsolid mesh
            """)
    }
}
