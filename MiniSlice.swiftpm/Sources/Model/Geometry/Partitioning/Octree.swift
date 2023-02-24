struct Octree<Value> {
    var root: Node = .init()
    
    struct Node {
        var values: [Value] = []
        var children: [Node] = [] {
            didSet {
                assert(isOctree)
            }
        }
        
        private var isOctree: Bool {
            children.isEmpty || children.count == 8
        }
        
        init(values: [Value] = [], children: [Node] = []) {
            self.values = values
            self.children = children
            assert(isOctree)
        }
    }
}

extension Octree.Node where Value: AxisAlignedBoundable {
    mutating func insert(value: Value, aabb: AxisAlignedBoundingBox, remainingDepth: Int) {
        if remainingDepth <= 0 {
            let octants = aabb.octants
            for (i, octant) in octants.enumerated() {
                if octant.contains(value) {
                    children[i].insert(value: value, aabb: octant, remainingDepth: remainingDepth - 1)
                    return
                }
            }
        }
        values.append(value)
    }
}

extension Octree where Value: AxisAlignedBoundable {
    mutating func insert(value: Value, aabb: AxisAlignedBoundingBox, maxDepth: Int) {
        root.insert(value: value, aabb: aabb, remainingDepth: maxDepth)
    }
}

extension Octree.Node: Equatable where Value: Equatable {}

extension Octree.Node: Hashable where Value: Hashable {}

extension Octree: Equatable where Value: Equatable {}

extension Octree: Hashable where Value: Hashable {}

extension Octree where Value == Triangle {
    init(mesh: Mesh, aabb: AxisAlignedBoundingBox, maxDepth: Int = 8) {
        for value in mesh {
            insert(value: value, aabb: aabb, maxDepth: maxDepth)
        }
    }
}
