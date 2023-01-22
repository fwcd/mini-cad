import SwiftUI
import UIKit

private let highlightRegex = try! NSRegularExpression(
    pattern: "\\b(?:let|for|in)\\b"
)

struct CodeEditor: UIViewRepresentable {
    @Binding var text: String
    var highlightColor: Color = .accentColor
    var textColor: Color = .primary
    var fontSize: CGFloat = 16
    
    var highlightedText: NSAttributedString {
        // We use NSString directly here to avoid costly linear-time index conversions
        let nsString = text as NSString
        let attributed = NSMutableAttributedString()
        var lastIndex = 0
        for match in highlightRegex.matches(in: text, range: NSRange(0..<nsString.length)) {
            let range = match.range
            if lastIndex < range.lowerBound {
                let chunk = NSAttributedString(string: nsString.substring(with: NSRange(lastIndex..<range.lowerBound)), attributes: [
                    .foregroundColor: UIColor(textColor),
                ])
                attributed.append(chunk)
            }
            let keyword = NSAttributedString(string: nsString.substring(with: range), attributes: [
                .foregroundColor: UIColor(highlightColor),
            ])
            attributed.append(keyword)
            lastIndex = range.upperBound
        }
        if lastIndex < nsString.length {
            let chunk = NSAttributedString(string: nsString.substring(from: lastIndex), attributes: [
                .foregroundColor: UIColor(textColor),
            ])
            attributed.append(chunk)
        }
        return attributed
    }
    
    func makeUIView(context: Context) -> UITextView {
        UITextView()
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.delegate = context.coordinator
        
        // Make sure to restore the selected text range since the cursor will otherwise move to the end
        let selected = uiView.selectedTextRange
        uiView.attributedText = highlightedText
        uiView.selectedTextRange = selected
        
        uiView.font = .monospacedSystemFont(ofSize: fontSize, weight: .regular)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func textViewDidChange(_ textView: UITextView) {
            text = textView.text
        }
    }
}

