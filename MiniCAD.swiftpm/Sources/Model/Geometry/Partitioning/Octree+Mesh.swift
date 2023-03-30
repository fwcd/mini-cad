extension Mesh {
    /// Create a (debug) mesh from a triangle octree.
    init(octree: Octree<Triangle>, aabb: AxisAlignedBoundingBox) {
        self.init(node: octree.root, aabb: aabb)
    }
    
    private init(node: Octree<Triangle>.Node, aabb: AxisAlignedBoundingBox) {
        if !node.children.isEmpty {
            var meshes = [Mesh]()
            for (child, octant) in zip(node.children, aabb.octants) {
                meshes.append(Mesh(node: child, aabb: octant))
            }
            self = meshes.disjointUnion
        } else {
            self.init(Cuboid(aabb))
        }
    }
}
