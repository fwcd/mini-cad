import SwiftUI
import SceneKit

struct PreviewSceneView: UIViewControllerRepresentable {
    @EnvironmentObject var viewModel: PreviewViewModel
    
    func makeUIViewController(context: Context) -> PreviewSceneViewController {
        PreviewSceneViewController()
    }
    
    func updateUIViewController(_ uiViewController: PreviewSceneViewController, context: Context) {
        uiViewController.scene = viewModel.scene
        uiViewController.cameraNode = viewModel.cameraNode
    }
}
