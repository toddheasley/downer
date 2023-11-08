import SwiftUI
import Downer

protocol EditorDelegate {
    func exec(_ action: Editor.Action)
    func open(_ url: URL)
    func focus()
}

@Observable public class Editor: CustomStringConvertible {
    public private(set) var isFocused: Bool = false
    public var document: Downer.Document
    public var baseURL: URL?
    
    public internal(set) var state: State? {
        didSet {
            isFocused = state?.isFocused ?? false
        }
    }
    
    public func exec(_ action: Action) {
        delegate?.exec(action)
    }
    
    public func focus() {
        delegate?.focus()
    }
    
    public func blur() {
#if canImport(UIKit)
        UIApplication.shared.blur()
#else
        fatalError("blur() has not been implemented")
#endif
    }
    
    var delegate: EditorDelegate?
    
    func open(_ url: URL) {
        delegate?.open(url)
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

extension Editor {
    
    // MARK: Action
    public enum Action: Equatable, CaseIterable, CustomStringConvertible {
        case createLink(_ href: URL? = nil)
        case insertImage(_ src: URL? = nil), insertOrderedList, insertUnorderedList
        case toggleBold, toggleItalic, toggleStrikethrough
        
        case createBlockquote, createHeading(_ level: Int = 1)
        case insertCheckbox, insertCodeBlock, insertLineBreak
        case insertTable(_ rows: Int = 1, _ cols: Int = 1), insertThemeBreak
        case toggleCode
        
        public static let `default`: [Self] = [
            .createLink(),
            .toggleBold,
            .toggleItalic,
            .toggleStrikethrough
        ]
        
        // MARK: CaseIterable
        public static let allCases: [Self] = [
            .createLink(),
            .insertImage(),
            .insertOrderedList,
            .insertUnorderedList,
            .toggleBold,
            .toggleItalic,
            .toggleStrikethrough,
            .createBlockquote,
            .createHeading(),
            .insertCheckbox,
            .insertCodeBlock,
            .insertLineBreak,
            .insertTable(),
            .insertThemeBreak,
            .toggleCode
        ]
        
        // MARK: CustomStringConvertible
        public var description: String {
            switch self {
            case .createLink:
                return "create link…"
            case .insertImage:
                return "insert image…"
            case .insertOrderedList:
                return "insert numbered list"
            case .insertUnorderedList:
                return "insert bulleted list"
            case .toggleBold:
                return "toggle bold"
            case .toggleItalic:
                return "toggle italic"
            case .toggleStrikethrough:
                return "toggle strike"
            case .createBlockquote:
                return "create blockquote"
            case .createHeading(let level):
                return "create #\(level) heading"
            case .insertCheckbox:
                return "insert checkbox"
            case .insertCodeBlock:
                return "insert code block"
            case .insertLineBreak:
                return "insert line break"
            case .insertTable(let rows, let cols):
                return "insert \(rows > 1 || cols > 1 ? "\(cols)x\(rows) " : "")table"
            case .insertThemeBreak:
                return "insert theme break"
            case .toggleCode:
                return "toggle code"
            }
        }
    }
}

extension Editor {
    
    // MARK: Link
    public struct Link: Decodable, CustomStringConvertible {
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
        
        // MARK: CustomStringConvertible
        public var description: String {
            return text.isEmpty ? "[\(href.absoluteString)]()" : "[\(text)](\(href.absoluteString))"
        }
    }
    
    // MARK: Selection
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
    
    // MARK: State
    public struct State: Decodable {
        public let selection: Selection
        public let isFocused: Bool
    }
}

extension EditorDelegate {
    func open(_ url: URL) {
#if canImport(Cocoa)
        NSWorkspace.shared.open(url)
#elseif canImport(UIKit)
        UIApplication.shared.open(url)
#else
        fatalError("open(_ url:) has not been implemented")
#endif
    }
}
#if canImport(UIKit)

private extension UIApplication {
    func blur() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
