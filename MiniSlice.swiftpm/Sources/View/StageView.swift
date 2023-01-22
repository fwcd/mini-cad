import SwiftUI
import SceneKit

struct StageView: View {
    @EnvironmentObject var viewModel: StageViewModel
    
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

struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        StageView()
    }
}
