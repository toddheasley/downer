import SwiftUI
import Downer

public struct EditorView: View {
    public let placeholder: String
    public let stylesheet: Stylesheet
    public let isEditible: Bool
    
    public init(_ placeholder: String = "", stylesheet: Stylesheet = .default, isEditible: Bool = true) {
        self.placeholder = placeholder
        self.stylesheet = stylesheet
        self.isEditible = isEditible
    }
    
    @Environment(Editor.self) private var editor: Editor
    
    // MARK: View
    public var body: some View {
        EditorWebView(stylesheet, placeholder: placeholder, isEditable: isEditible)
            .ignoresSafeArea(.keyboard)
            .environment(editor)
    }
}
