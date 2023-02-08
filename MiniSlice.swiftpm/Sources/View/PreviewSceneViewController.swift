import UIKit
import SceneKit

class PreviewSceneViewController: UIViewController, UIGestureRecognizerDelegate {
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
    
    private var panRecognizer: UIPanGestureRecognizer!
    private var scrollRecognizer: UIPanGestureRecognizer!
    private var panSensitivity: Double = 0.0001
    private var zoomSensitivity: Double = 0.0002
    private var sceneView: SCNView!
    
    override func loadView() {
        sceneView = SCNView()
        
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        panRecognizer.delegate = self
        sceneView.addGestureRecognizer(panRecognizer)
        
        scrollRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleScroll))
        scrollRecognizer.delegate = self
        scrollRecognizer.allowedScrollTypesMask = .all
        scrollRecognizer.allowedTouchTypes = []
        sceneView.addGestureRecognizer(scrollRecognizer)
        
        view = sceneView
    }
    
    @objc
    private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let delta = recognizer.velocity(in: view)
        
        let controller = sceneView.defaultCameraController
        controller.rotateBy(x: Float(-delta.x * panSensitivity), y: -Float(delta.y * panSensitivity))
    }
    
    @objc
    private func handleScroll(_ recognizer: UIPanGestureRecognizer) {
        let delta = recognizer.velocity(in: view)
        
        let controller = sceneView.defaultCameraController
        controller.dolly(toTarget: -Float(delta.y * zoomSensitivity))
    }
}
