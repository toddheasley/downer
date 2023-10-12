import Foundation

public struct Image: Element {
    public let source: URL
    
    // MARK: Element
    public static let elements: [Element.Type] = [Text.self]
    
    public let elements: [Element]
    
    public func description(_ format: Format) -> String {
        let description: String = (elements.first as? Text)?.description ?? ""
        let source: String = source.absoluteString
        switch format {
        case .markdown:
            return "![\(description)](\(source))"
        case .hypertext:
            guard !description.isEmpty else {
                return "<img src=\"\(source)\">"
            }
            return "<img src=\"\(source)\" alt=\"\(description)\">"
        }
    }
    
    public init?(_ description: String) {
        guard let description: Description = Self.parse(description) else {
            return nil
        }
        let attributes: [String] = description.attributes.components(separatedBy: "\"")
        guard attributes.count > 2, attributes[0] == "source: ",
        let source: URL = URL(string: attributes[1]) else {
            return nil
        }
        self.source = source
        elements = description.elements
    }
}
