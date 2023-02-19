import UIKit

final class CodeTextView: UITextView {
    var _undoManager: UndoManager? = nil
    
    override var undoManager: UndoManager? { _undoManager }
}
