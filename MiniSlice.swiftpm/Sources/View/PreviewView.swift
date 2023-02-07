import SwiftUI
import SceneKit

struct PreviewView: View {
    @EnvironmentObject var viewModel: PreviewViewModel
    var dragSensitivity: Double = 1
    
    @State private var initialEulerAngles: SCNVector3? = nil
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // TODO: Zoom when scrolling, do we need to implement a custom SCNSceneView wrapper for this?
            PreviewSceneView()
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let factor = 0.001
                            
                            if let cameraNode = viewModel.cameraNode {
                                let initialEulerAngles = initialEulerAngles ?? cameraNode.eulerAngles
                                
                                cameraNode.eulerAngles.x = initialEulerAngles.x + Float(value.translation.height * dragSensitivity * factor)
                                cameraNode.eulerAngles.y = initialEulerAngles.y + Float(value.translation.width * dragSensitivity * factor)
                                
                                self.initialEulerAngles = initialEulerAngles
                            }
                        }
                )
            OptionsView()
                .frame(maxWidth: 300)
                .padding(10)
        }
    }
}

