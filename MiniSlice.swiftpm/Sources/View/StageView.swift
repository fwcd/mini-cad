import SwiftUI
import SceneKit

struct StageView: View {
    @EnvironmentObject var viewModel: StageViewModel
    
    var body: some View {
        SceneView(scene: viewModel.scene)
    }
}

struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        StageView()
    }
}
