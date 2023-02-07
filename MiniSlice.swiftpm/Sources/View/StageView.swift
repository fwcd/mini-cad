import SwiftUI
import SceneKit

struct PreviewView: View {
    @EnvironmentObject var viewModel: PreviewViewModel
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // TODO: Zoom when scrolling, do we need to implement a custom SCNSceneView wrapper for this?
            SceneView(
                scene: viewModel.scene,
                pointOfView: viewModel.cameraNode,
                options: .allowsCameraControl
            )
            OptionsView()
                .frame(maxWidth: 300)
                .padding(10)
        }
    }
}

