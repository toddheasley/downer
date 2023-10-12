public struct HTMLBlock: Element {
    public let source: String
    
    // MARK: Element
    public static let elements: [Element.Type] = []
    
    public let elements: [Element] = []
    
    public func description(_ format: Format) -> String {
        switch format {
        case .markdown:
            return "\(source)\n\n"
        case .hypertext:
            return "\(source)\n"
        }
    }
    
    public init?(_ description: String) {
        let components: [String] = description.components(separatedBy: "\n")
        guard components[0] == Self.name else {
            return nil
        }
        source = components.dropFirst().joined(separator: "\n")
    }
}
