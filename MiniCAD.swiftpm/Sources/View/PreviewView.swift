import SwiftUI
import SceneKit

struct PreviewView: View {
    @EnvironmentObject private var viewModel: PreviewViewModel
    @State private var optionsShown: Bool = true
    
    var body: some View {
        // TODO: Zoom when scrolling, do we need to implement a custom SCNSceneView wrapper for this?
        PreviewSceneView()
            .edgesIgnoringSafeArea(.all)
            .overlay(alignment: .bottomTrailing) {
                VStack(spacing: 5) {
                    Button {
                        withAnimation(.spring()) {
                            optionsShown = !optionsShown
                        }
                    } label: {
                        Image(systemName: optionsShown ? "chevron.down" : "chevron.up")
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderless)
                    if optionsShown {
                        OptionsView()
                    }
                    PreviewToolbarView()
                }
                .frame(maxWidth: optionsShown ? 250 : 200)
                .modifier(PreviewOverlay())
                .padding(ViewConstants.padding)
            }
    }
}

