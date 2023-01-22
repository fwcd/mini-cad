import SwiftUI
import UIKit

private let highlightRegex = try! NSRegularExpression(
    pattern: "\\b(?:let|for|in)\\b"
)

struct CodeEditor: UIViewRepresentable {
    @Binding var text: String
    
    var highlightedText: NSAttributedString {
        let attributed = NSMutableAttributedString()
        var lastIndex = text.startIndex
        for match in highlightRegex.matches(in: text, range: NSRange(text.startIndex..., in: text)) {
            if let range = Range(match.range, in: text) {
                if lastIndex < range.lowerBound {
                    let chunk = NSAttributedString(string: String(text[lastIndex..<range.lowerBound]), attributes: [
                        .foregroundColor: UIColor(.primary),
                    ])
                    attributed.append(chunk)
                }
                let keyword = NSAttributedString(string: String(text[range]), attributes: [
                    .foregroundColor: UIColor.tintColor,
                ])
                attributed.append(keyword)
                lastIndex = range.upperBound
            }
        }
        if lastIndex < text.endIndex {
            let chunk = NSAttributedString(string: String(text[lastIndex...]), attributes: [
                .foregroundColor: UIColor(.primary),
            ])
            attributed.append(chunk)
        }
        return attributed
    }
    
    func makeUIView(context: Context) -> UITextView {
        UITextView()
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = highlightedText
        uiView.font = .monospacedSystemFont(ofSize: 16, weight: .regular)
    }
}

