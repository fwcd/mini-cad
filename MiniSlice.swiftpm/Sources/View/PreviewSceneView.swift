import SwiftUI
import SceneKit

struct PreviewSceneView: UIViewRepresentable {
    @EnvironmentObject var viewModel: PreviewViewModel
    
    func makeUIView(context: Context) -> SCNView {
        let uiView = SCNView()
        uiView.allowsCameraControl = true
        return uiView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        uiView.scene = viewModel.scene
        uiView.pointOfView?.camera?.usesOrthographicProjection = viewModel.options.usesOrthographicProjection
    }
}
