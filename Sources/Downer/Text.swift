public struct Text: Element {
    
    // MARK: Element
    public static let elements: [Element.Type] = []
    
    public let elements: [Element] = []
    
    public func description(_ format: Format) -> String {
        return description
    }
    
    public init?(_ description: String) {
        guard let description: Description = Self.parse(description), description.attributes.hasPrefix("\""), description.attributes.hasSuffix("\"") else {
            return nil
        }
        self.description = "\(description.attributes.dropFirst().dropLast())"
    }
    
    // MARK: CustomStringConvertible
    public let description: String
}
