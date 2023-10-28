func EditorHTML(_ name: String, stylesheet: Stylesheet, placeholder: String = "", isEditable: Bool = true) -> String { """
<!DOCTYPE html>
<meta charset="UTF-8">
<meta name="viewport" content="initial-scale=1.0, user-scalable=no, viewport-fit=cover">
<style>

\(stylesheet)

</style>
<p id="placeholder" disabled>\(placeholder)</p>
<div id="editor" spellcheck="false"\(isEditable ? " contenteditable" : "")>
    
</div>
<script>
    
    let editor = document.getElementById("editor");
    let placeholder = document.getElementById("placeholder")
    let muteSelectionchange = false;
    let isFocused = false;

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
    
    const getState = function() {
        let state = {
            "isFocused": isFocused
        };
        let selection = document.getSelection();
        if (!selection || selection.rangeCount == 0) {
            return state;
        }
        let rect = selection.getRangeAt(0).getBoundingClientRect();
        if (rect.x == 0 && rect.y == 0 && rect.width == 0 && rect.height == 0) {
            rect = selection.focusNode.getBoundingClientRect();
        }
        state["selection"] = {
            "text": selection.getRangeAt(0).toString(),
            "rect": [rect.x, rect.y, rect.width, rect.height]
        };
        if (selection.anchorNode && selection.anchorNode.parentElement) {
            let element = selection.anchorNode.parentElement;
            state["selection"]["nodeName"] = element.nodeName;
            if (element.nodeName == "A") {
                state["selection"]["link"] = {
                    "href": element.getAttribute("href"),
                    "text": element.text
                };
            }
        }
        return JSON.stringify(state);
    }
    
    const setHTML = function(html) {
        editor.innerHTML = html;
        togglePlaceholder();
    }
    
    const getHTML = function() {
        return editor.innerHTML;
    }
    
    const isEmpty = function() {
        return editor.innerText.trim().length == 0;
    }

    window.addEventListener("load", function() {
        postMessage("load");
        togglePlaceholder();
    });
    
    document.addEventListener("selectionchange", function(event) {
        if (!muteSelectionchange) {
            postMessage("selectionchange");
            togglePlaceholder();
        }
    });
    
    editor.addEventListener("input", function() {
        postMessage("input");
        togglePlaceholder();
    });
    
    editor.addEventListener("click", function() {
        postMessage("click");
    });
    
    editor.addEventListener("focus", function() {
        isFocused = true;
    });
    
    editor.addEventListener("blur", function() {
        isFocused = false;
    });
    
    editor.addEventListener("touchstart", function() {
        muteSelectionchange = true;
    });
    
    editor.addEventListener("touchcancel", function() {
        postMessage("selectionchange");
        muteSelectionchange = false;
    });
    
    editor.addEventListener("touchend", function() {
        postMessage("selectionchange");
        muteSelectionchange = false;
    });
    
    editor.addEventListener("mousedown", function() {
        muteSelectionchange = true;
    });
    
    editor.addEventListener("mouseup", function() {
        postMessage("selectionchange");
        muteSelectionchange = false;
    });
    
</script>
""" }
