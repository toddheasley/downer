import SwiftUI
import WebKit
import Downer

struct EditorWebView {
    let stylesheet: Stylesheet
    let placeholder: String
    let isEditible: Bool
    
    init(_ stylesheet: Stylesheet = .default, placeholder: String = "", isEditable: Bool = true) {
        self.stylesheet = stylesheet
        self.placeholder = placeholder
        self.isEditible = isEditable
    }
    
    @Environment(Editor.self) private var editor: Editor
    private let name: String = "editor"
}

extension EditorWebView {
    class Coordinator: NSObject, EditorDelegate, WKNavigationDelegate, WKScriptMessageHandler {
        var webView: WKWebView?
        
        init(_ parent: EditorWebView) {
            self.parent = parent
            super.init()
        }
        
        private let parent: EditorWebView
        
        // MARK: EditorDelegate
        func createLink(_ href: URL) {
            webView?.evaluateJavaScript("createLink('\(href.absoluteString)')")
        }
        
        func insertImage(_ src: URL) {
            webView?.evaluateJavaScript("insertImage('\(src.absoluteString)')");
        }
        
        func insertOrderedList() {
            webView?.evaluateJavaScript("insertOrderedList()");
        }
        
        func insertUnorderedList() {
            webView?.evaluateJavaScript("insertUnorderedList()");
        }
        
        func toggleBold() {
            webView?.evaluateJavaScript("toggleBold()");
        }
        
        func toggleItalic() {
            webView?.evaluateJavaScript("toggleItalic()");
        }
        
        func toggleStrikethrough() {
            webView?.evaluateJavaScript("toggleStrikethrough()");
        }
        
        func toggleUnderline() {
            webView?.evaluateJavaScript("toggleUnderline()");
        }
        
        private func getState(clicked: Bool = false) {
            webView?.evaluateJavaScript("getState()") { json, _ in
                guard let json: String = json as? String,
                      let data: Data = json.data(using: .utf8),
                      let state: Editor.State = try? JSONDecoder().decode(Editor.State.self, from: data) else {
                    return
                }
                self.parent.editor.state = state
                if clicked {
                    self.parent.editor.linkActivated()
                }
            }
        }
        
        private func getHTML() {
            webView?.evaluateJavaScript("getHTML()") { html, _ in
                guard let html: String = html as? String,
                      let document: Downer.Document  = Downer.Document(html, convertHTML: true) else {
                    return
                }
                self.parent.editor.document = document
            }
        }
        
        private func setHTML() {
            let html: String = parent.editor.document.description(.hypertext)
            webView?.evaluateJavaScript("setHTML('\(html.escapedForEval())')");
        }
        
        // MARK: WKNavigationDelegate
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
            switch navigationAction.navigationType {
            case .linkActivated:
                parent.editor.linkActivated(navigationAction.request.url)
                return .cancel
            case .other, .reload:
                return .allow // Allow content loading
            default:
                return .cancel // Cancel navigation
            }
        }
        
        // MARK: WKScriptMessageHandler
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            switch message.body as? String {
            case "load":
                setHTML()
            case "selectionchange":
                getState()
            case "click":
                getState(clicked: true)
            case "input":
                getHTML()
            default:
                break
            }
        }
    }
}

#if canImport(UIKit)
extension EditorWebView: UIViewRepresentable {
    
    // MARK: UIViewRepresentable
    func makeUIView(context: Context) -> WKWebView {
        let webView: WKWebView = WebView()
        webView.configuration.userContentController.add(context.coordinator, name: name)
        webView.navigationDelegate = context.coordinator
        context.coordinator.webView = webView
        editor.delegate = context.coordinator
        webView.backgroundColor = .clear
        webView.isOpaque = false
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(EditorHTML(name, stylesheet: stylesheet, placeholder: placeholder, isEditable: isEditible), baseURL: editor.baseURL)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}

private class WebView: WKWebView {
    let _inputAccessoryView: UIView = UIView()
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: WKWebView
    override var inputAccessoryView: UIView? {
        return _inputAccessoryView
    }
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        
        _inputAccessoryView.backgroundColor = .red.withAlphaComponent(0.5)
        _inputAccessoryView.frame.size.height = 44.0
    }
}

#elseif canImport(Cocoa)
extension EditorWebView: NSViewRepresentable {
    
    // MARK: NSViewRepresentable
    func makeNSView(context: Context) -> WKWebView {
        let webView: WKWebView = WKWebView()
        webView.configuration.userContentController.add(context.coordinator, name: name)
        webView.navigationDelegate = context.coordinator
        context.coordinator.webView = webView
        editor.delegate = context.coordinator
        webView.underPageBackgroundColor = .clear
        webView.setValue(false, forKey: "drawsBackground") // isOpaque
        return webView
    }
    
    func updateNSView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(EditorHTML(name, stylesheet: stylesheet, placeholder: placeholder), baseURL: editor.baseURL)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}

#endif
#Preview("Editor Web View") {
    EditorWebView(placeholder: "Placeholder")
        .environment(Editor())
}
