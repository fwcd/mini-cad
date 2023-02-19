import Combine
import SceneKit

class PreviewViewModel: ObservableObject {
    @Published private(set) var scene: SCNScene
    @Published var options: Options = .init()
    
    private var meshesNode: SCNNode
    
    init() {
        let scene = SCNScene(named: "Preview.scn")!
        self.scene = scene
        
        let root = scene.rootNode
        
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.color = UIColor.gray
        let ambientLightNode = SCNNode()
        ambientLightNode.light = ambientLight
        root.addChildNode(ambientLightNode)
        
        meshesNode = SCNNode()
        root.addChildNode(meshesNode)
        
        let camera = SCNCamera()
        camera.usesOrthographicProjection = options.usesOrthographicProjection
        camera.orthographicScale = 8
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 14, y: 10, z: 14)
        cameraNode.eulerAngles.x = -.pi / 8
        cameraNode.eulerAngles.y = .pi / 4
        root.addChildNode(cameraNode)
        
        let dirLight = SCNLight()
        dirLight.type = .directional
        let dirLightNode = SCNNode()
        dirLightNode.light = dirLight
        dirLightNode.eulerAngles.x = .pi / 8
        dirLightNode.eulerAngles.y = .pi / 8
        cameraNode.addChildNode(dirLightNode)
        
        root.addChildNode(AxisNode(direction: .init(x: 1)))
        root.addChildNode(AxisNode(direction: .init(y: 1)))
        root.addChildNode(AxisNode(direction: .init(z: 1)))
    }
    
    func update(meshes: [Mesh]) {
        // TODO: Be smarter about this, e.g. by adding identity to cuboids and diffing them
        
        meshesNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        
        for mesh in meshes {
            meshesNode.addChildNode(makeNode(for: mesh))
        }
    }
    
    private func makeNode(for mesh: Mesh) -> SCNNode {
        let geometry = SCNGeometry(mesh: mesh)
        geometry.firstMaterial?.diffuse.contents = UIColor.tintColor
        return SCNNode(geometry: geometry)
    }
}
