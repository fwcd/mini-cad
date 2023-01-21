import Combine
import SceneKit

class StageViewModel: ObservableObject {
    @Published var scene = SCNScene(named: "Stage.scn")!
    
    init() {
        let cameraNode = SCNNode()
        let camera = SCNCamera()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
        scene.rootNode.addChildNode(cameraNode)
        
        let cubeBox = SCNBox()
        cubeBox.firstMaterial?.diffuse.contents = UIColor.orange
        let cube = SCNNode(geometry: cubeBox)
        cube.position = SCNVector3(x: 0, y: 0, z: 0)
        scene.rootNode.addChildNode(cube)
    }
}
