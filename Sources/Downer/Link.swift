import Foundation
import UniformTypeIdentifiers

public struct Link: Element {
    public let destination: URL
    
    // MARK: Element
    public static let elements: [Element.Type] = [Emphasis.self, Image.self, InlineCode.self, LineBreak.self, SoftBreak.self, Strikethrough.self, Strong.self, Text.self]
    
    public let elements: [Element]
    
    public func description(_ format: Format) -> String {
        let description: String = elements.description(format)
        let destination: String = destination.absoluteString
        switch format {
        case .markdown:
            return "[\(description)](\(destination))"
        case .hypertext:
            switch self.destination.contentType {
            case UTType.audio:
                return "<audio preload=\"metadata\" controls><source src=\"\(destination)\"></audio>"
            case UTType.video:
                return "<video preload=\"metadata\" controls><source src=\"\(destination)\"></video>"
            default:
                return "<a href=\"\(destination)\">\(!description.isEmpty ? description : destination)</a>"
            }
        }
    }
    
    public init?(_ description: String) {
        guard let description: Description = Self.parse(description) else {
            return nil
        }
        let attributes: [String] = description.attributes.components(separatedBy: "destination: ")
        guard attributes.count == 2,
              let destination: URL = URL(string: "\(attributes[1].dropFirst().dropLast())") else {
            return nil
        }
        self.destination = destination
        elements = description.elements
    }
}

private extension URL {
    var contentType: UTType? {
        switch pathExtension {
        case "m4a", "aac", "mp3":
            return .audio
        case "m4v", "mp4":
            return .video
        default:
            return nil
        }
    }
}
