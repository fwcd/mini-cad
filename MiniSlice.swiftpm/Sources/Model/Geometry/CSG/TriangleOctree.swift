struct TriangleOctree {
    var root: Node = .init()
    
    struct Node {
        var triangles: [Triangle] = []
        var children: [Node] = [] {
            didSet {
                assert(isOctree)
            }
        }
        
        private var isOctree: Bool {
            children.isEmpty || children.count == 8
        }
        
        init(triangles: [Triangle] = [], children: [Node] = []) {
            self.triangles = triangles
            self.children = children
            assert(isOctree)
        }
        
        mutating func insert(triangle: Triangle, aabb: AxisAlignedBoundingBox, remainingDepth: Int) {
            if remainingDepth <= 0 {
                let octants = aabb.octants
                for (i, octant) in octants.enumerated() {
                    if octant.fullyContains(triangle) {
                        children[i].insert(triangle: triangle, aabb: octant, remainingDepth: remainingDepth - 1)
                        return
                    }
                }
            }
            triangles.append(triangle)
        }
    }
    
    mutating func insert(triangle: Triangle, aabb: AxisAlignedBoundingBox, maxDepth: Int) {
        root.insert(triangle: triangle, aabb: aabb, remainingDepth: maxDepth)
    }
}

extension TriangleOctree {
    init(mesh: Mesh, aabb: AxisAlignedBoundingBox, maxDepth: Int = 8) {
        for triangle in mesh {
            insert(triangle: triangle, aabb: aabb, maxDepth: maxDepth)
        }
    }
}
