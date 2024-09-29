import Markdown

public struct Document: Element, ExpressibleByStringLiteral {
    
    // MARK: Element
    public static let elements: [Element.Type] = [BlockQuote.self, CodeBlock.self, Heading.self, HTMLBlock.self, OrderedList.self, Paragraph.self, Table.self, ThematicBreak.self, UnorderedList.self]
    
    public let elements: [Element]
    
    public func description(_ format: Format) -> String {
        return "\u{FEFF}\(elements.description(format).trimmingCharacters(in: .whitespacesAndNewlines))\n"
    }
    
    public init?(_ description: String) {
        let document: Markdown.Document = Markdown.Document(parsing: description.replacingOccurrences(of: "\n\n", with: "\n \n"))
        guard let description: Description = Self.parse(document.debugDescription()) else {
            return nil
        }
        elements = description.elements
    }
    
    // ExpressibleByStringLiteral
    public init(stringLiteral value: String) {
        elements = Self(value)?.elements ?? []
    }
}
#if canImport(SwiftUI) && !os(watchOS) && !os(tvOS)

import SwiftUI
import UniformTypeIdentifiers

extension Document: FileDocument {
    public enum Error: Swift.Error, Identifiable {
        case unsupported(UTType), decodingFailed, encodingFailed, generic(String)
        
        // MARK: Identifiable
        public var id: Int {
            return localizedDescription.hashValue
        }
    }
    
    // MARK: FileDocument
    public static let readableContentTypes: [UTType] = [.text]
    public static let writableContentTypes: [UTType] = Format.allCases.map { $0.contentType }
    
    public init(configuration: ReadConfiguration) throws {
        guard let data: Data = configuration.file.regularFileContents,
              let description: String = String(data: data, encoding: .utf8),
              let document: Self = Self(description) else {
            throw Error.decodingFailed
        }
        self = document
    }
    
    public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        guard let format: Format = Format(contentType: configuration.contentType) else {
            throw Error.unsupported(configuration.contentType)
        }
        guard let data: Data = description(format).data(using: .utf8) else {
            throw Error.encodingFailed
        }
        return FileWrapper(regularFileWithContents: data)
    }
}
#endif
