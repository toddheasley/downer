public struct ThematicBreak: Element {
    
    // MARK: Element
    public static let elements: [Element.Type] = []
    
    public let elements: [Element] = []
    
    public func description(_ format: Format) -> String {
        switch format {
        case .markdown:
            return "-----\n\n"
        case .hypertext:
            return "<hr>\n"
        }
    }
    
    public init?(_ description: String) {
        guard let _: Description = Self.parse(description) else {
            return nil
        }
    }
}
