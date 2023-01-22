import Combine
import SceneKit

class StageViewModel: ObservableObject {
    @Published private(set) var scene: SCNScene
    @Published var options: Options = .init() {
        didSet {
            updateCamera()
        }
    }
    
    @Published private(set) var cameraNode: SCNNode? = nil
    private var cuboidsNode: SCNNode
    
    private var camera: SCNCamera? {
        cameraNode?.camera
    }
    
    init() {
        let scene = SCNScene(named: "Stage.scn")!
        self.scene = scene
        
        let dirLight = SCNLight()
        dirLight.type = .directional
        let dirLightNode = SCNNode()
        dirLightNode.light = dirLight
        dirLightNode.eulerAngles.x = .pi / 8
        dirLightNode.eulerAngles.y = .pi / 8
        scene.rootNode.addChildNode(dirLightNode)
        
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.color = UIColor.gray
        let ambientLightNode = SCNNode()
        ambientLightNode.light = ambientLight
        scene.rootNode.addChildNode(ambientLightNode)
        
        cuboidsNode = SCNNode()
        scene.rootNode.addChildNode(cuboidsNode)
        
        updateCamera()
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
    
    private func updateCamera() {
        if let cameraNode = cameraNode {
            cameraNode.removeFromParentNode()
        }
        
        let camera = SCNCamera()
        camera.usesOrthographicProjection = options.usesOrthographicProjection
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 1, y: 1, z: 5)
        cameraNode.eulerAngles.x = -.pi / 16
        cameraNode.eulerAngles.y = .pi / 16
        scene.rootNode.addChildNode(cameraNode)
        
        self.cameraNode = cameraNode
        print("Updated camera node")
    }
}
