import SwiftUI
import UIKit

private let highlightRegex = try! NSRegularExpression(
    pattern: "\\b(?:let|for|in)\\b"
)

struct CodeEditor: UIViewRepresentable {
    @Binding var text: String
    
    var highlightedText: AttributedString {
        var attributed = AttributedString()
        var lastIndex = text.startIndex
        for match in highlightRegex.matches(in: text, range: NSRange(text.startIndex..., in: text)) {
            if let range = Range(match.range, in: text) {
                if lastIndex < range.lowerBound {
                    var chunk = AttributedString(text[lastIndex..<range.lowerBound])
                    chunk.foregroundColor = .primary
                    attributed.append(chunk)
                }
                var keyword = AttributedString(text[range])
                keyword.foregroundColor = .accentColor
                attributed.append(keyword)
                lastIndex = range.upperBound
            }
        }
        if lastIndex < text.endIndex {
            var chunk = AttributedString(text[lastIndex...])
            chunk.foregroundColor = .primary
            attributed.append(chunk)
        }
        return attributed
    }
    
    func makeUIView(context: Context) -> UITextView {
        UITextView()
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = NSAttributedString(highlightedText)
        uiView.font = .monospacedSystemFont(ofSize: 16, weight: .regular)
    }
}

