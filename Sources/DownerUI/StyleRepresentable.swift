protocol StyleRepresentable {
    var styleValue: String { get }
    init?(style value: String)
}

extension StyleRepresentable {
    init?(style value: String) {
        fatalError("init(style:) has not been implemented")
    }
}
