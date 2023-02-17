import Foundation

private let patterns: [(String, (Substring) -> Token?, String)] = [
    ("let", { _ in .let }, "\\blet\\b"),
    ("for", { _ in .for }, "\\bfor\\b"),
    ("in", { _ in .in }, "\\bin\\b"),
    ("toExclusive", { _ in .binaryOperator(.toExclusive) }, "\\b\\.\\.<\\b"),
    ("toInclusive", { _ in .binaryOperator(.toInclusive) }, "\\b\\.\\.\\.\\b"),
    ("assign", { _ in .assign }, "\\s=\\s"),
    ("newline", { _ in .newline }, "\n"),
    ("leftParen", { _ in .leftParen }, "\\("),
    ("rightParen", { _ in .rightParen }, "\\)"),
    ("leftCurly", { _ in .leftCurly }, "\\{"),
    ("rightCury", { _ in .rightCurly }, "\\}"),
    ("comma", { _ in .comma }, ","),
    ("float", { raw in .float(String(raw)) }, "-?\\d+\\.\\d+"),
    ("int", { raw in .int(String(raw)) }, "-?\\d+"),
    ("identifier", { raw in .identifier(String(raw)) }, "\\w+"),
]
private let regex = try! NSRegularExpression(
    pattern: patterns
        .map { (k, _, v) in "(?<\(k)>\(v))" }
        .joined(separator: "|")
)

/// Lexes the given raw recipe/program into a series of tokens.
func tokenize(_ raw: String) -> [Token] {
    regex.matches(in: raw, range: NSRange(raw.startIndex..., in: raw))
        .compactMap { match in
            for (name, makeToken, _) in patterns {
                let group = match.range(withName: name)
                if group.length > 0, let range = Range(group, in: raw) {
                    return makeToken(raw[range])
                }
            }
            return nil
        }
}
