import SwiftUI
import Downer

protocol EditorDelegate {
    
}

@Observable class Editor: CustomStringConvertible {
    var delegate: EditorDelegate?
    var document: Downer.Document
    var baseURL: URL?
    
    func open(url: URL) throws {
        
    }
    
    func description(_ format: Format) -> String {
        return description
    }
    
    convenience init?(_ description: String, baseURL: URL? = nil) {
        guard let document: Downer.Document = Downer.Document(description) else {
            return nil
        }
        self.init(document, baseURL: baseURL)
    }
    
    init(_ document: Downer.Document = "", baseURL: URL? = nil) {
        self.document = document
        self.baseURL = baseURL
    }
    
    // MARK: CustomStringConvertible
    var description: String {
        return document.description
    }
}
