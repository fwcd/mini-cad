extension Array {
    subscript(safely i: Int) -> Element? {
        i >= 0 && i < count ? self[i] : nil
    }
}
