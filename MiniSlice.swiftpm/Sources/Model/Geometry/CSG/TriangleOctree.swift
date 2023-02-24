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
    }
    
    mutating func insert(triangle: Triangle) {
        
    }
}

extension TriangleOctree {
    init(mesh: Mesh) {
        for triangle in mesh {
            
        }
    }
}
