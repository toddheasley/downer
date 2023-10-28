import SwiftUI
import Downer

protocol EditorDelegate {
    func createLink(_ href: URL)
    func insertImage(_ src: URL)
    func insertOrderedList()
    func insertUnorderedList()
    func linkActivated(_ href: URL)
    func toggleBold()
    func toggleItalic()
    func toggleStrikethrough()
}

@Observable public class Editor: CustomStringConvertible {
    public struct Link: Decodable {
        public let text: String
        public let href: URL
        
        init(_ text: String? = nil, href: URL) {
            self.text = text ?? ""
            self.href = href
        }
        
        // MARK: Decodable
        public init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<Key> = try decoder.container(keyedBy: Key.self)
            guard let href: URL = try container.decodeIfPresent(URL.self, forKey: .href) else {
                throw URLError(.cannotDecodeContentData)
            }
            let text: String? = try container.decodeIfPresent(String.self, forKey: .text)
            self.init(text, href: href)
        }
        
        private enum Key: CodingKey {
            case text, href
        }
    }
    
    public struct Selection: Decodable {
        public let text: String
        public let nodeName: String?
        public let rect: CGRect
        public let link: Link?
        
        init(_ text: String? = nil, nodeName: String? = nil, rect: CGRect? = nil, link: Link? = nil) {
            self.text = text ?? ""
            self.nodeName = nodeName
            self.rect = rect ?? .zero
            self.link = link
        }
        
        // MARK: Decodable
        public init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<Key> = try decoder.container(keyedBy: Key.self)
            let text: String? = try container.decodeIfPresent(String.self, forKey: .text)
            let nodeName: String? = try container.decodeIfPresent(String.self, forKey: .nodeName)
            var rect: CGRect? = nil
            let _rect: [CGFloat]? = try container.decodeIfPresent([CGFloat].self, forKey: .rect)
            if let _rect, _rect.count == 4 {
                rect = CGRect(x: _rect[0], y: _rect[1], width: _rect[2], height: _rect[3])
            }
            let link: Link? = try container.decodeIfPresent(Link.self, forKey: .link)
            self.init(text, nodeName: nodeName, rect: rect, link: link)
        }
        
        private enum Key: CodingKey {
            case text, nodeName, rect, link
        }
    }
    
    public struct State: Decodable {
        public let selection: Selection
        public let isFocused: Bool
    }
    
    public internal(set) var state: State?
    public var document: Downer.Document
    public var baseURL: URL?
    
    var delegate: EditorDelegate?
    
    func linkActivated(_ href: URL?) {
        guard let href else { return }
        delegate?.linkActivated(href)
    }
    
    func linkActivated() {
        linkActivated(state?.selection.link?.href)
    }
    
    public convenience init?(_ description: String, baseURL: URL? = nil) {
        guard let document: Downer.Document = Downer.Document(description) else {
            return nil
        }
        self.init(document, baseURL: baseURL)
    }
    
    public init(_ document: Downer.Document = "", baseURL: URL? = nil) {
        self.document = document
        self.baseURL = baseURL
    }
    
    // MARK: CustomStringConvertible
    public var description: String {
        return document.description
    }
}

extension EditorDelegate {
    func linkActivated(_ href: URL) {
#if canImport(Cocoa)
        NSWorkspace.shared.open(href)
#elseif canImport(UIKit)
        UIApplication.shared.open(href)
#else
        fatalError("linkActivated(_ href:) has not been implemented")
#endif
    }
}
