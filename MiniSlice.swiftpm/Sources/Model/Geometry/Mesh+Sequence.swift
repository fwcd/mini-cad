struct MeshIterator: IteratorProtocol {
    private let mesh: Mesh
    private var faceIterator: Array<Mesh.Face>.Iterator
    
    fileprivate init(mesh: Mesh, faceIterator: Array<Mesh.Face>.Iterator) {
        self.mesh = mesh
        self.faceIterator = faceIterator
    }
    
    mutating func next() -> Triangle? {
        faceIterator.next().map { mesh.triangle(for: $0) }
    }
}

extension Mesh: Sequence {
    func makeIterator() -> MeshIterator {
        MeshIterator(mesh: self, faceIterator: faces.makeIterator())
    }
}
