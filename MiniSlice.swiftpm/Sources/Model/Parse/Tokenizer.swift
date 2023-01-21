import Foundation

private let regex = try! NSRegularExpression(pattern: [
    ("let", "let"),
    ("assign", "="),
    ("newline", "\n"),
    ("leftParen", "\\("),
    ("rightParen", "\\)"),
    ("leftCurly", "\\{"),
    ("rightCury", "\\}"),
    ("float", "-?\\d+\\.\\d+"),
    ("int", "-?\\d+"),
    ("identifier", "\\w+"),
].map { (k, v) in "(?<\(k)>\(v))" }.joined(separator: "|"))

func tokenize(_ raw: String) -> [Token] {
    regex.matches(in: raw, range: NSRange(raw.startIndex..., in: raw))
        .compactMap { match in
            let range = Range(match.range, in: raw)!
            if match.range(withName: "let").length > 0 {
                return .let
            } else if match.range(withName: "assign").length > 0 {
                return .assign
            } else if match.range(withName: "newline").length > 0 {
                return .newline
            } else if match.range(withName: "leftParen").length > 0 {
                return .leftParen
            } else if match.range(withName: "rightParen").length > 0 {
                return .rightParen
            } else if match.range(withName: "leftCurly").length > 0 {
                return .leftCurly
            } else if match.range(withName: "rightCurly").length > 0 {
                return .rightCurly
            } else if match.range(withName: "float").length > 0 {
                guard let value = Double(raw[range]) else { return nil }
                return .float(value)
            } else if match.range(withName: "int").length > 0 {
                guard let value = Int(raw[range]) else { return nil }
                return .int(value)
            } else if match.range(withName: "identifier").length > 0 {
                return .identifier(String(raw[range]))
            } else {
                return nil
            }
        }
}
