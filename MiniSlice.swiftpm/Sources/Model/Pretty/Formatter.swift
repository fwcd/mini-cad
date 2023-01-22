struct Formatter: Hashable {
    var indentSize = 0
    
    var indented: Self {
        Self(indentSize: indentSize + 2)
    }
    
    var indent: String {
        String(repeating: " ", count: indentSize)
    }
    var lineBreak: String {
        "\n\(indent)"
    }
    var blockOpener: String {
        "{\(indented.lineBreak)"
    }
    var blockCloser: String {
        "\(lineBreak)}"
    }
}
