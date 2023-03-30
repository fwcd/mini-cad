import SwiftUI
import SceneKit

struct PreviewSceneView: UIViewRepresentable {
    @EnvironmentObject var viewModel: PreviewViewModel
    
    func makeUIView(context: Context) -> SCNView {
        let uiView = SCNView()
        uiView.allowsCameraControl = true
        // SceneKit seems to swap out the pointOfView node whenever the camera is panned, therefore we manually restore its child nodes.
        context.coordinator.pointOfViewObservation = uiView.defaultCameraController.observe(\.pointOfView, options: [.new]) { (cameraController, _) in
            if let pointOfView = cameraController.pointOfView {
                let childs = context.coordinator.previousPointOfView?.childNodes ?? []
                for child in childs {
                    child.removeFromParentNode()
                    pointOfView.addChildNode(child)
                }
                context.coordinator.previousPointOfView = pointOfView
            }
        }
        return uiView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        uiView.scene = viewModel.scene
        uiView.pointOfView?.camera?.usesOrthographicProjection = viewModel.options.usesOrthographicProjection
        
        if viewModel.options.renderAsWireframes {
            uiView.debugOptions.insert(.renderAsWireframe)
        } else {
            uiView.debugOptions.remove(.renderAsWireframe)
        }
        
        if viewModel.options.showBoundingBoxes {
            uiView.debugOptions.insert(.showBoundingBoxes)
        } else {
            uiView.debugOptions.remove(.showBoundingBoxes)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator {
        fileprivate var previousPointOfView: SCNNode?
        fileprivate var pointOfViewObservation: NSKeyValueObservation?
    }
}
