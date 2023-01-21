import Combine
import SceneKit

class StageViewModel: ObservableObject {
    @Published var scene = SCNScene(named: "Stage.scn")!
    
    init() {
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
        scene.rootNode.addChildNode(cameraNode)
        
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
        cubeBox.firstMaterial?.diffuse.contents = UIColor.orange
        let cube = SCNNode(geometry: cubeBox)
        cube.position = SCNVector3(x: 0, y: 0, z: 0)
        scene.rootNode.addChildNode(cube)
    }
}
