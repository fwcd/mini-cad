import SwiftUI
import UIKit

struct CodeEditor: UIViewRepresentable {
    @Binding var text: String
    var tokens: [Token]
    var textColor: Color = .primary
    var fontSize: CGFloat = 16
    var autoIndent: Int? = 2
    
    @Environment(\.undoManager) private var undoManager
    
    var highlightedText: NSAttributedString {
        // We use NSString directly here to avoid costly linear-time index conversions
        let nsString = text as NSString
        let attributed = NSMutableAttributedString()
        var lastIndex = 0
        for token in tokens {
            guard let color = token.kind.highlightColor else { continue }
            let range = NSRange(token.sourceRange)
            if lastIndex < range.lowerBound {
                let chunk = NSAttributedString(string: nsString.substring(with: NSRange(lastIndex..<range.lowerBound)), attributes: [
                    .foregroundColor: UIColor(textColor),
                ])
                attributed.append(chunk)
            }
            let highlighted = NSAttributedString(string: nsString.substring(with: range), attributes: [
                .foregroundColor: UIColor(color),
            ])
            attributed.append(highlighted)
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
    
    func makeUIView(context: Context) -> CodeTextView {
        CodeTextView()
    }
    
    func updateUIView(_ uiView: CodeTextView, context: Context) {
        uiView._undoManager = undoManager
        
        uiView.autocorrectionType = .no
        uiView.autocapitalizationType = .none
        uiView.spellCheckingType = .no
        
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
            guard let autoIndent = autoIndent,
                  let selectedRange = textView.selectedTextRange else {
                return true
            }
            
            let isEnter = text == "\n"
            let isTab = text == "\t"
            let isBackspace = text.isEmpty && selectedRange.start == selectedRange.end
            
            guard isEnter || isTab || isBackspace,
                  let lineStart = textView.tokenizer.position(from: selectedRange.start, toBoundary: .line, inDirection: .storage(.backward)),
                  let linePrefixRange = textView.textRange(from: lineStart, to: selectedRange.start),
                let linePrefix = textView.text(in: linePrefixRange) else {
                return true
            }
                      
            if isEnter {
                // Perform indented line break
                let lineIndent = linePrefix.prefix { $0.isWhitespace }
                var newIndent = lineIndent
                
                if linePrefix.last == "{" {
                    newIndent += String(repeating: " ", count: autoIndent)
                }
                
                let indented = "\(text)\(newIndent)"
                textView.replace(selectedRange, withText: indented)
                return false
            } else if isBackspace && !linePrefix.isEmpty && linePrefix.allSatisfy(\.isWhitespace) {
                // Dedent on backspace
                let dedented = String(linePrefix.dropLast(autoIndent))
                textView.replace(linePrefixRange, withText: dedented)
                return false
            } else if isTab {
                // Indent with spaces on tab
                let indent = String(repeating: " ", count: autoIndent)
                textView.replace(selectedRange, withText: indent)
                return false
            }
            
            return true
        }
    }
}

struct CodeEditor_Previews: PreviewProvider {
    static var previews: some View {
        CodeEditor(text: .constant("\(demoRecipe)"), tokens: tokenize("\(demoRecipe)"))
    }
}
