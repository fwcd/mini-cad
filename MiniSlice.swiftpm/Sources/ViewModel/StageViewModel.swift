import Combine
import SceneKit

class StageViewModel: ObservableObject {
    @Published var scene = SCNScene(named: "Stage.scn")
}
