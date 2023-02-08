import Combine
import SceneKit

class PreviewViewModel: ObservableObject {
    @Published private(set) var scene: SCNScene
    @Published var options: Options = .init()
    
    private var cuboidsNode: SCNNode
    
    init() {
        let scene = SCNScene(named: "Preview.scn")!
        self.scene = scene
        
        let root = scene.rootNode
        
        let dirLight = SCNLight()
        dirLight.type = .directional
        let dirLightNode = SCNNode()
        dirLightNode.light = dirLight
        dirLightNode.eulerAngles.x = .pi / 8
        dirLightNode.eulerAngles.y = .pi / 8
        root.addChildNode(dirLightNode)
        
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.color = UIColor.gray
        let ambientLightNode = SCNNode()
        ambientLightNode.light = ambientLight
        root.addChildNode(ambientLightNode)
        
        cuboidsNode = SCNNode()
        root.addChildNode(cuboidsNode)
        
        let camera = SCNCamera()
        camera.usesOrthographicProjection = options.usesOrthographicProjection
        camera.orthographicScale = 8
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 14, y: 10, z: 14)
        cameraNode.eulerAngles.x = -.pi / 8
        cameraNode.eulerAngles.y = .pi / 4
        root.addChildNode(cameraNode)
        
        root.addChildNode(AxisNode(direction: .init(x: 1)))
        root.addChildNode(AxisNode(direction: .init(y: 1)))
        root.addChildNode(AxisNode(direction: .init(z: 1)))
    }
    
    func update(cuboids: [Cuboid]) {
        // TODO: Be smarter about this, e.g. by adding identity to cuboids and diffing them
        
        cuboidsNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        
        for cuboid in cuboids {
            cuboidsNode.addChildNode(makeNode(for: cuboid))
        }
    }
    
    private func makeNode(for cuboid: Cuboid) -> SCNNode {
        let box = SCNBox()
        box.firstMaterial?.diffuse.contents = UIColor.tintColor
        let cube = SCNNode(geometry: box)
        cube.position = SCNVector3(cuboid.center)
        cube.scale = SCNVector3(cuboid.size)
        return cube
    }
}
