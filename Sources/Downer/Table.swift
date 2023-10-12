public struct Table: Element {
    
    // MARK: Element
    public static let elements: [Element.Type] = [Body.self, Head.self]
    
    public let elements: [Element]
    
    public func description(_ format: Format) -> String {
        let description: String = elements.description(format)
        switch format {
        case .markdown:
            return "\(description)\n"
        case .hypertext:
            return "<table>\n\(description)</table>\n"
        }
    }
    
    public init?(_ description: String) {
        guard let description: Description = Self.parse(description) else {
            return nil
        }
        elements = description.elements
    }
}
