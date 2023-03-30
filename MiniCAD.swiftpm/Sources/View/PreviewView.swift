import SwiftUI
import SceneKit

struct PreviewView: View {
    @EnvironmentObject var viewModel: PreviewViewModel
    
    var body: some View {
        // TODO: Zoom when scrolling, do we need to implement a custom SCNSceneView wrapper for this?
        PreviewSceneView()
            .overlay(alignment: .topLeading) {
                OptionsView()
                    .frame(maxWidth: 300)
                    .modifier(PreviewOverlay())
                    .padding(ViewConstants.padding)
            }
            .overlay(alignment: .bottomLeading) {
                ToolbarView()
                    .modifier(PreviewOverlay())
                    .padding(ViewConstants.padding)
            }
    }
}

