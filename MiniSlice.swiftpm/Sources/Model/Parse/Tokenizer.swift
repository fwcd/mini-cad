import Foundation

private let patterns: [(String, (Substring) -> Token?, String)] = [
    ("let", { _ in .let }, "let"),
    ("assign", { _ in .assign }, "="),
    ("newline", { _ in .newline }, "\n"),
    ("leftParen", { _ in .leftParen }, "\\("),
    ("rightParen", { _ in .rightParen }, "\\)"),
    ("leftCurly", { _ in .leftCurly }, "\\{"),
    ("rightCury", { _ in .rightCurly }, "\\}"),
    ("comma", { _ in .comma }, ","),
    ("float", { raw in Double(raw).map { .float($0) } }, "-?\\d+\\.\\d+"),
    ("int", { raw in Int(raw).map { .int($0) } }, "-?\\d+"),
    ("identifier", { raw in .identifier(String(raw)) }, "\\w+"),
]
private let regex = try! NSRegularExpression(
    pattern: patterns
        .map { (k, _, v) in "(?<\(k)>\(v))" }
        .joined(separator: "|")
)

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
