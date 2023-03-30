import Foundation

/// A range in the source code. Stores both `String.Index` and Cocoa-style UTF-16 indices internally to avoid costly index conversions.
struct SourceRange: Hashable {
    let lines: ClosedRange<Int>
    let range: Range<String.Index>
    let nsRange: NSRange
    
    /// Combines the smallest range containing both this and the given range.
    func merging(_ rhs: Self) -> Self {
        let startLine = min(lines.lowerBound, rhs.lines.lowerBound)
        let startIndex = min(range.lowerBound, rhs.range.lowerBound)
        let startUTF16 = min(nsRange.lowerBound, rhs.nsRange.lowerBound)
        let endLine = max(lines.upperBound, rhs.lines.upperBound)
        let endIndex = max(range.upperBound, rhs.range.upperBound)
        let endUTF16 = max(nsRange.upperBound, rhs.nsRange.upperBound)
        
        return Self(
            lines: startLine...endLine,
            range: startIndex..<endIndex,
            nsRange: NSRange(location: startUTF16, length: endUTF16 - startUTF16)
        )
    }
}

extension Range where Bound == String.Index {
    init(_ srcRange: SourceRange) {
        self = srcRange.range
    }
}

extension NSRange {
    init(_ srcRange: SourceRange) {
        self = srcRange.nsRange
    }
}
