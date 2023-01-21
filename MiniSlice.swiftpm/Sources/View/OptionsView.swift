import SwiftUI

struct OptionsView: View {
    @EnvironmentObject var stage: StageViewModel
    
    var body: some View {
        VStack {
            Toggle("Orthographic Camera", isOn: $stage.usesOrthoProjection)
        }
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView()
    }
}
