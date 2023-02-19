import Foundation

/// A range in the source code. Stores both `String.Index` and Cocoa-style UTF-16 indices internally to avoid costly index conversions.
struct SourceRange: Hashable {
    let range: Range<String.Index>
    let nsRange: NSRange
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
