#if !os(watchOS) && !os(tvOS)
import SwiftUI
import WebKit
import Downer

struct EditorWebView {
    let placeholder: String
    let stylesheet: Stylesheet
    let isEditable: Bool
    
    init(_ placeholder: String = "", stylesheet: Stylesheet = .default, isEditable: Bool = true) {
        self.placeholder = placeholder
        self.stylesheet = stylesheet
        self.isEditable = isEditable
    }
    
    @Environment(Editor.self) private var editor: Editor
    private let name: String = "editor"
}

extension EditorWebView {
    class Coordinator: NSObject, @preconcurrency EditorDelegate, WKNavigationDelegate, WKScriptMessageHandler {
        var webView: WKWebView?
        
        init(_ parent: EditorWebView) {
            self.parent = parent
            super.init()
        }
        
        private let parent: EditorWebView
        
        // MARK: EditorDelegate
        func exec(_ action: Editor.Action) {
            switch action {
            case .createLink(let href):
                guard let href else { break }
                webView?.evaluateJavaScript("createLink('\(href.absoluteString)')")
            case .insertImage(let src):
                guard let src else { break }
                webView?.evaluateJavaScript("insertImage('\(src.absoluteString)')")
            case .insertOrderedList:
                webView?.evaluateJavaScript("insertOrderedList()")
            case .insertUnorderedList:
                webView?.evaluateJavaScript("insertUnorderedList()")
            case .toggleBold:
                webView?.evaluateJavaScript("toggleBold()")
            case .toggleItalic:
                webView?.evaluateJavaScript("toggleItalic()")
            case .toggleStrikethrough:
                webView?.evaluateJavaScript("toggleStrikethrough()")
            default:
                break
            }
        }
        
        func focus() {
            webView?.evaluateJavaScript("focusEditor()")
        }
        
        private func getState(_ handler: ((Editor.State?) -> Void)? = nil) {
            webView?.evaluateJavaScript("getState()") { json, _ in
                if let json: String = json as? String,
                   let data: Data = json.data(using: .utf8),
                   let state: Editor.State = try? JSONDecoder().decode(Editor.State.self, from: data) {
                    self.parent.editor.state = state
                    handler?(state)
                } else {
                    handler?(nil)
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
            case .other, .reload:
                return .allow // Allow content loading
            case .linkActivated:
                if let url = navigationAction.request.url {
                    parent.editor.open(url)
                }
                fallthrough
            default:
                return .cancel // Cancel navigation
            }
        }
        
        // MARK: WKScriptMessageHandler
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            switch message.body as? String {
            case "load":
                setHTML()
            case "blur", "focus", "selectionchange":
                getState()
            case "click":
                getState { state in
                    guard let url: URL = state?.selection.link?.href else { return }
                    self.open(url)
                }
            case "paste":
                break
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
        let webView: WKWebView = WKWebView()
        webView.configuration.userContentController.add(context.coordinator, name: name)
        webView.navigationDelegate = context.coordinator
        context.coordinator.webView = webView
        editor.delegate = context.coordinator
        webView.backgroundColor = .clear
        webView.isOpaque = false
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(EditorHTML(name, stylesheet: stylesheet, placeholder: placeholder, isEditable: isEditable), baseURL: editor.baseURL)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}
#if !os(visionOS)

private class WebView: WKWebView {
    
    // MARK: WKWebView
    override var inputAccessoryView: UIView? { nil }
}
#endif

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
    EditorWebView("Placeholder")
        .environment(Editor())
}
#endif
