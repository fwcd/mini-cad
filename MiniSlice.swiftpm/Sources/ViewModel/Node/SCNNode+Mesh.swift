import SceneKit

extension SCNNode {
    convenience init(mesh: Mesh) {
        let source = SCNGeometrySource(vertices: mesh.vertices.map { SCNVector3($0) })
        let element = SCNGeometryElement(indices: mesh.facesFlat.map { UInt32($0) }, primitiveType: .triangles)
        let geometry = SCNGeometry(sources: [source], elements: [element])
        self.init(geometry: geometry)
    }
}
