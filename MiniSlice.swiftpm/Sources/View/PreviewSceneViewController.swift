import UIKit
import SceneKit

class PreviewSceneViewController: UIViewController {
    var scene: SCNScene? {
        didSet {
            sceneView.scene = scene
        }
    }
    var cameraNode: SCNNode? {
        didSet {
            sceneView.pointOfView = cameraNode
        }
    }
    
    private var sceneView: SCNView!
    
    override func loadView() {
        sceneView = SCNView()
        view = sceneView
    }
}
