import Foundation
import OSLog
import CoreText

private let log = Logger(subsystem: "MiniSlice", category: "TextLabel")

/// A 3D text label.
struct TextLabel: Hashable {
    var content: String
    var center: Vec3 = .zero
    var fontName: String = "Helvetica"
    var fontSize: Double = 24
}

extension Mesh {
    init(_ label: TextLabel) {
        let font = CTFontCreateWithName(label.fontName as CFString, label.fontSize, nil)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let attributedString = NSAttributedString(string: label.content, attributes: attributes)
        let line = CTLineCreateWithAttributedString(attributedString)
        let path = CGMutablePath()
        
        for run in CTLineGetGlyphRuns(line) as! [CTRun] {
            var glyphs = [CGGlyph](repeating: 0, count: CTRunGetGlyphCount(run))
            var positions = [CGPoint](repeating: .zero, count: glyphs.count)
            let range = CFRangeMake(0, glyphs.count)
            CTRunGetGlyphs(run, range, &glyphs)
            CTRunGetPositions(run, range, &positions)
            
            for (glyph, position) in zip(glyphs, positions) {
                var transform = CGAffineTransform(translationX: position.x, y: position.y)
                if let glyphPath = CTFontCreatePathForGlyph(font, glyph, &transform) {
                    path.addPath(glyphPath)
                } else {
                    log.warning("Could not create path for glyph \(glyph)")
                }
            }
        }
        
        self.init(path)
    }
}
