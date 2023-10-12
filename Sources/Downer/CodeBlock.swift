public struct CodeBlock: Element {
    public let language: String
    public let source: String
    
    // MARK: Element
    public static let elements: [Element.Type] = []
    
    public let elements: [Element] = []
    
    public func description(_ format: Format) -> String {
        switch format {
        case .markdown:
            return "```\(language)\n\(source)\n```\n\n"
        case .hypertext:
            return "<pre>\n\(source.escaped)\n</pre>\n"
        }
    }
    
    public init?(_ description: String) {
        let components: [String] = description.components(separatedBy: "\n")
        let attributes: [String] = components[0].components(separatedBy: " language: ")
        guard attributes[0] == Self.name, attributes.count == 2 else {
            return nil
        }
        language = attributes[1] != "none" ? attributes[1] : ""
        source = components.dropFirst().joined(separator: "\n").replacingOccurrences(of: "\n \n", with: "\n\n")
    }
}
