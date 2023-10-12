public struct LineBreak: Element {
    
    // MARK: Element
    public static let elements: [Element.Type] = []
    
    public let elements: [Element] = []
    
    public func description(_ format: Format) -> String {
        switch format {
        case .markdown:
            return "  \n"
        case .hypertext:
            return "<br>"
        }
    }
    
    public init?(_ description: String) {
        guard let _: Description = Self.parse(description) else {
            return nil
        }
    }
}
