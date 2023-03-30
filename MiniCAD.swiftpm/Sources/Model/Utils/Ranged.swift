import Foundation

/// A lexical token. Before parsing the program/recipe is preprocessed into a sequence of tokens.
@propertyWrapper
struct Ranged<Wrapped> {
    var wrappedValue: Wrapped
    var sourceRange: SourceRange?
    
    var projectedValue: Self { self }
    
    init(wrappedValue: Wrapped, sourceRange: SourceRange? = nil) {
        self.wrappedValue = wrappedValue
        self.sourceRange = sourceRange
    }
}

extension Ranged: Equatable where Wrapped: Equatable {}

extension Ranged: Hashable where Wrapped: Hashable {}
