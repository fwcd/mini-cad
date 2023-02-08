import SwiftUI
import SceneKit

struct PreviewView: View {
    var body: some View {
        ZStack(alignment: .topTrailing) {
            PreviewSceneView()
            OptionsView()
                .frame(maxWidth: 300)
                .padding(10)
        }
    }
}

