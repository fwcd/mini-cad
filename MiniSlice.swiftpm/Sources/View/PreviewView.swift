import SwiftUI
import SceneKit

struct PreviewView: View {
    @EnvironmentObject var viewModel: PreviewViewModel
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // TODO: Zoom when scrolling, do we need to implement a custom SCNSceneView wrapper for this?
            PreviewSceneView()
            OptionsView()
                .frame(maxWidth: 300)
                .padding(8)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12.0))
                .padding(8)
        }
    }
}

