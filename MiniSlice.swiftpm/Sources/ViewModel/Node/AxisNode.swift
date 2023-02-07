import SceneKit

class AxisNode: SCNNode {
    init(direction: Vec3) {
        super.init()
        
        let thickness: CGFloat = 0.01
        let length: CGFloat = 100.0
        let boxAxis = Vec3(z: 1)
        
        let material = SCNMaterial()
        let color = UIColor.gray
        material.lightingModel = .constant
        material.ambient.contents = UIColor.black
        material.diffuse.contents = color
        material.emission.contents = color
        
        let box = SCNBox(width: thickness, height: thickness, length: length, chamferRadius: thickness / 2)
        box.materials = [material]
        
        let child = SCNNode(geometry: box)
        child.rotation = SCNVector4(direction.cross(boxAxis), w: .pi / 2)
        addChildNode(child)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
}
