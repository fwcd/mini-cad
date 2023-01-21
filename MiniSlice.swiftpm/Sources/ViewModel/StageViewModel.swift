import Combine
import SceneKit

class StageViewModel: ObservableObject {
    @Published private(set) var scene: SCNScene
    @Published private(set) var cameraNode: SCNNode? = nil
    @Published var options: Options = .init() {
        didSet {
            updateCamera()
        }
    }
    
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
        
        let cubeBox = SCNBox()
        cubeBox.firstMaterial?.diffuse.contents = UIColor.tintColor
        let cube = SCNNode(geometry: cubeBox)
        cube.position = SCNVector3(x: 0, y: 0, z: 0)
        scene.rootNode.addChildNode(cube)
        
        updateCamera()
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
