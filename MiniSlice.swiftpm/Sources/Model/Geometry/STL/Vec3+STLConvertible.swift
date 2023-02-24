extension Vec3: STLConvertible {
    var asAsciiStl: String {
        "\(x) \(y) \(z)"
    }
}
