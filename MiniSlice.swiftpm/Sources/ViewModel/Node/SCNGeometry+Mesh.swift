import SceneKit

extension SCNGeometry {
    convenience init(mesh: Mesh) {
        let source = SCNGeometrySource(vertices: mesh.vertices.map { SCNVector3($0) })
        let element = SCNGeometryElement(indices: mesh.facesFlat.map { UInt32($0) }, primitiveType: .triangles)
        self.init(sources: [source], elements: [element])
    }
}
