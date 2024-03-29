import Foundation

private typealias TokenPattern = (String, (Substring) -> Token.Kind, String)

private let basePatterns: [TokenPattern] = [
    ("comment", { _ in .comment }, "//.*"),
    ("string", { raw in .string(String(raw.dropFirst().dropLast())) }, #""[^"\n]*""#),
    ("let", { _ in .let }, "\\blet\\b"),
    ("for", { _ in .for }, "\\bfor\\b"),
    ("in", { _ in .in }, "\\bin\\b"),
    ("if", { _ in .if }, "\\bif\\b"),
    ("else", { _ in .else }, "\\belse\\b"),
    ("func", { _ in .func }, "\\bfunc\\b"),
    ("assign", { _ in .assign }, "\\s=\\s"),
    ("newline", { _ in .newline }, "\n"),
    ("leftParen", { _ in .leftParen }, "\\("),
    ("rightParen", { _ in .rightParen }, "\\)"),
    ("leftCurly", { _ in .leftCurly }, "\\{"),
    ("rightCury", { _ in .rightCurly }, "\\}"),
    ("comma", { _ in .comma }, ","),
    ("float", { raw in .float(String(raw)) }, "-?\\d+\\.\\d+"),
    ("int", { raw in .int(String(raw)) }, "-?\\d+"),
    ("true", { _ in .bool(true) }, "\\btrue\\b"),
    ("false", { _ in .bool(false) }, "\\bfalse\\b"),
    ("identifier", { raw in .identifier(String(raw)) }, "\\w+"),
    ("colon", { _ in .colon }, ":"),
]

private let binaryOperatorPatterns: [TokenPattern] = BinaryOperator.allCases.enumerated().map { (i, op) in
    ("bo\(i)", { _ in .binaryOperator(op) }, NSRegularExpression.escapedPattern(for: op.pretty()))
}
private let prefixOperatorPatterns: [TokenPattern] = PrefixOperator.allCases.enumerated().map { (i, op) in
    ("po\(i)", { _ in .prefixOperator(op) }, NSRegularExpression.escapedPattern(for: op.pretty()))
}
private let operatorPatterns: [TokenPattern] = binaryOperatorPatterns + prefixOperatorPatterns // Order matters, e.g. to prefer != over !

private let patterns: [TokenPattern] = basePatterns + operatorPatterns

private let regex = try! NSRegularExpression(
    pattern: patterns
        .map { (k, _, v) in "(?<\(k)>\(v))" }
        .joined(separator: "|")
)

/// Lexes the given raw recipe/program into a series of tokens.
func tokenize(_ raw: String) -> [Token] {
    var tokens: [Token] = []
    var line: Int = 0
    
    for match in regex.matches(in: raw, range: NSRange(raw.startIndex..., in: raw)) {
        for (name, makeTokenKind, _) in patterns {
            let group = match.range(withName: name)
            if group.length > 0, let range = Range(group, in: raw) {
                let kind = makeTokenKind(raw[range])
                let token = Token(kind: kind, sourceRange: SourceRange(lines: line...line, range: range, nsRange: group))
                tokens.append(token)
                // NOTE: This way of line-tracking currently assumes that all tokens are single-line
                if kind == .newline {
                    line += 1
                }
            }
        }
    }
    
    return tokens
}
