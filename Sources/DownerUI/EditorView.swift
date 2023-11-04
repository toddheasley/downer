import SwiftUI
import Downer

public struct EditorView: View {
    public let placeholder: String
    public let stylesheet: Stylesheet
    public let isEditable: Bool
    
    public init(_ placeholder: String = "", stylesheet: Stylesheet = .default, isEditable: Bool = true) {
        self.placeholder = placeholder
        self.stylesheet = stylesheet
        self.isEditable = isEditable
    }
    
    public func editorToolbar<Toolbar: View>(@ViewBuilder toolbar: () -> Toolbar = {
        EditorToolbar()
    }) -> some View {
        ZStack(alignment: .toolbar) {
            self
            toolbar()
        }
    }
    
    @Environment(Editor.self) private var editor: Editor
    
    // MARK: View
    public var body: some View {
        EditorWebView(placeholder, stylesheet: stylesheet, isEditable: isEditable)
            .ignoresSafeArea(.keyboard)
            .environment(editor)
    }
}

#Preview("Editor View") {
    @State var editor: Editor = Editor()
    return EditorView("Placeholder")
        .environment(editor)
}

private extension Alignment {
    static var toolbar: Self {
#if canImport(UIKit)
        return bottom
#else
        return .topTrailing
#endif
    }
}
