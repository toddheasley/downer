public protocol Element: Sendable, CustomStringConvertible {
    static var name: String {
        get
    }
    
    static var elements: [Element.Type] {
        get
    }
    
    var elements: [Element] {
        get
    }
    
    func description(_ format: Format) -> String
    
    init?(_ description: String)
}

extension Element {
    public static var name: String {
        return String(describing: Self.self)
    }
    
    typealias Description = (elements: [Element], attributes: String)
    
    static func parse(_ description: String) -> Description? {
        var description: String = description.replacingOccurrences(of: "└─", with: "├─")
        while description.contains("   ├─") || description.contains("   │") {
            description = description.replacingOccurrences(of: "   ├─", with: "│  ├─")
            description = description.replacingOccurrences(of: "   │", with: "│  │")
        }
        description = description.trimmingCharacters(in: .whitespacesAndNewlines)
        var components: [String] = description.components(separatedBy: "\n").map { component in
            return component.hasPrefix("   ") ? "\(component.dropFirst(3))" : component
        }
        let attributes: [String] = components[0].components(separatedBy: " ")
        guard !attributes[0].isEmpty, attributes[0] == name else {
            return nil
        }
        components = "\n\(components.dropFirst().joined(separator: "\n"))".components(separatedBy: "\n├─ ")
        components = components.dropFirst().map { component in
            return component.replacingOccurrences(of: "\n│  ", with: "\n")
        }
        var elements: [Element] = []
        for component in components {
            guard let element = Self.elements.compactMap({ $0.init(component) }).first else {
                continue
            }
            elements.append(element)
        }
        return (elements, attributes.dropFirst().joined(separator: " "))
    }
    
    // MARK: CustomStringConvertible
    public var description: String {
        return description(.markdown).trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension Array where Element == Downer.Element {
    func description(_ format: Format) -> String {
        return map { $0.description(format) }.joined()
    }
}
