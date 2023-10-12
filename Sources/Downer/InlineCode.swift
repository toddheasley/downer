public struct InlineCode: Element {
    public let source: String
    
    // MARK: Element
    public static let elements: [Element.Type] = []
    
    public let elements: [Element] = []
    
    public func description(_ format: Format) -> String {
        switch format {
        case .markdown:
            return "`\(source)`"
        case .hypertext:
            return "<code>\(source.escaped)</code>"
        }
    }
    
    public init?(_ description: String) {
        guard let attributes: String = Self.parse(description)?.attributes, attributes.hasPrefix("`"), attributes.hasSuffix("`") else {
            return nil
        }
        source = "\(attributes.dropFirst().dropLast())"
    }
}
