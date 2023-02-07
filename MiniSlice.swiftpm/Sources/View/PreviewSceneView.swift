import SwiftUI
import SceneKit

struct PreviewSceneView: UIViewRepresentable {
    @EnvironmentObject var viewModel: PreviewViewModel
    
    func makeUIView(context: Context) -> SCNView {
        SCNView()
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        uiView.scene = viewModel.scene
        uiView.pointOfView = viewModel.cameraNode
    }
}
