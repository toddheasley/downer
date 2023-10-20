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
                let html: String = parent.editor.document.description(.hypertext)
                webView?.evaluateJavaScript("setHTML('\(html.escaped())')");
            case "selectionchange":
                webView?.evaluateJavaScript("getHTML()") { html, _ in
                    guard let html: String = html as? String,
                          let document: Downer.Document  = Downer.Document(html, convertHTML: true) else {
                        return
                    }
                    self.parent.editor.document = document
                }
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
        webView.loadHTMLString(EditorHTML(name, stylesheet: stylesheet, placeholder: placeholder, isEditable: isEditible), baseURL: editor.baseURL)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
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

private func EditorHTML(_ name: String, stylesheet: Stylesheet, placeholder: String = "", isEditable: Bool = true) -> String { """
<!DOCTYPE html>
<meta charset="UTF-8">
<meta name="viewport" content="initial-scale=1.0, user-scalable=no, viewport-fit=cover">
<style>

\(stylesheet)

</style>
<p id="placeholder" disabled>\(placeholder)</p>
<div id="\(name)" spellcheck="false"\(isEditable ? " contenteditable" : "")>
    
</div>
<script>
    
    "use strict";
    
    let editor = document.getElementById("editor");
    let placeholder = document.getElementById("placeholder")
    let selectionchangeMuted = false;
    let focused = false;

    const postMessage = function(message) {
        window.webkit.messageHandlers.\(name).postMessage(message);
    }
    
    const togglePlaceholder = function() {
        placeholder.style.display = isEmpty() ? "block" : "none";
    }
    
    const toggleBold = function() {
        document.execCommand("bold", false, null);
    }
    
    const toggleItalic = function() {
        document.execCommand("italic", false, null);
    }
    
    const toggleStrikethrough = function() {
        document.execCommand("strikethrough", false, null);
    }
    
    const toggleUnderline = function() {
        document.execCommand("underline", false, null);
    }
    
    const createLink = function(href) {
        document.execCommand("createLink", false, href);
    }
    
    const insertOrderedList = function() {
        document.execCommand("insertOrderedList", false, null);
    }
    
    const insertUnorderedList = function() {
        document.execCommand("insertUnorderedList", false, null);
    }
    
    const insertImage = function(src) {
        postMessage("insertImage");
        document.execCommand("InsertImage", false, src);
    }
    
    const setHTML = function(html) {
        editor.innerHTML = html;
        togglePlaceholder();
    }
    
    const getHTML = function() {
        return editor.innerHTML;
    }
    
    const isEmpty = function() {
        return (editor.innerText.length == 0 || editor.innerText == "\\n");
    }

    window.addEventListener("load", function() {
        postMessage("load");
        togglePlaceholder();
    });
    
    document.addEventListener("selectionchange", function(event) {
        if (!selectionchangeMuted) {
            postMessage("selectionchange");
            togglePlaceholder();
        }
    });

    editor.addEventListener("focus", function() {
        focused = true;
    });
    
    editor.addEventListener("blur", function() {
        focused = false;
    });
    
    editor.addEventListener("touchstart", function() {
        selectionchangeMuted = true;
    });
    
    editor.addEventListener("touchcancel", function() {
        postMessage("selectionchange");
        selectionchangeMuted = false;
    });
    
    editor.addEventListener("touchend", function() {
        postMessage("selectionchange");
        selectionchangeMuted = false;
    });
    
    editor.addEventListener("mousedown", function() {
        selectionchangeMuted = true;
    });
    
    editor.addEventListener("mouseup", function() {
        postMessage("selectionchange");
        selectionchangeMuted = false;
    });
    
</script>
""" }

private extension String {
    func escaped() -> Self {
        return self.unicodeScalars.map { char in
            guard (char.value < 32 && char.value != 9) || char.value == 39 else {
                return Self(char)
            }
            return Self(char.escaped(asASCII: true))
        }.joined().replacingOccurrences(of: "\u{FEFF}", with: "")
    }
}
