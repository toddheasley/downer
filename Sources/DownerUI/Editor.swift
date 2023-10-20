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
    func toggleUnderline()
}

@Observable public class Editor: CustomStringConvertible {
    public var document: Downer.Document
    public var baseURL: URL?
    
    var delegate: EditorDelegate?
    
    func linkActivated(_ href: URL?) {
        guard let href else { return }
        delegate?.linkActivated(href)
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
#if canImport(Cocoa) || canImport(UIKit)

extension EditorDelegate {
    func linkActivated(_ href: URL) {
#if canImport(Cocoa)
        NSWorkspace.shared.open(href)
#elseif canImport(UIKit)
        UIApplication.shared.open(href)
#endif
    }
}
#endif
