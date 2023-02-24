struct TriangleOctree {
    var triangles: [Triangle] = []
    var children: [TriangleOctree] = [] {
        didSet {
            assert(isOctree)
        }
    }
    
    private var isOctree: Bool {
        children.isEmpty || children.count == 8
    }
}
