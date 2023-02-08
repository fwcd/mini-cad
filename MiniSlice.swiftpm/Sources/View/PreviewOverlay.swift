import SwiftUI

struct PreviewOverlay: ViewModifier {
    var padding = ViewConstants.padding
    var cornerRadius = ViewConstants.cornerRadius
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius))
    }
}

