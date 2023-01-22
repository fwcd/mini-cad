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
    var autoIndent: Int? = 2
    
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
        Coordinator(text: $text, autoIndent: autoIndent)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        @Binding private var text: String
        private let autoIndent: Int?
        
        init(text: Binding<String>, autoIndent: Int?) {
            _text = text
            self.autoIndent = autoIndent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            text = textView.text
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            // TODO: Can we be sure that range corresponds to selectedTextRange?
            if text == "\n",
               let autoIndent = autoIndent,
               let selectedRange = textView.selectedTextRange,
               let lineStart = textView.tokenizer.position(from: selectedRange.start, toBoundary: .line, inDirection: .storage(.backward)),
               let linePrefixRange = textView.textRange(from: lineStart, to: selectedRange.start),
               let linePrefix = textView.text(in: linePrefixRange) {
                let lineIndent = linePrefix.prefix { $0.isWhitespace }
                var newIndent = lineIndent
                
                if linePrefix.last == "{" {
                    newIndent += String(repeating: " ", count: autoIndent)
                }
                
                textView.replace(selectedRange, withText: "\(text)\(newIndent)")
                return false
            }
            return true
        }
    }
}

struct CodeEditor_Previews: PreviewProvider {
    static var previews: some View {
        CodeEditor(text: .constant("\(demoRecipe)"))
    }
}
