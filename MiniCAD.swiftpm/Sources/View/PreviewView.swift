import SwiftUI
import SceneKit

struct PreviewView: View {
    @EnvironmentObject var viewModel: PreviewViewModel
    
    var body: some View {
        // TODO: Zoom when scrolling, do we need to implement a custom SCNSceneView wrapper for this?
        PreviewSceneView()
            .edgesIgnoringSafeArea(.all)
            .overlay(alignment: .bottomTrailing) {
                VStack {
                    OptionsView()
                    PreviewToolbarView()
                }
                    .frame(maxWidth: 250)
                    .modifier(PreviewOverlay())
                    .padding(ViewConstants.padding)
            }
    }
}

