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
    let placeholder = document.getElementById("placeholder");
    var muteSelectionchange = false;
    var selectedRange = null;
    var isFocused = false;
    
    const createLink = function(href) {
        document.execCommand("createLink", false, href);
    };
    
    const insertImage = function(src) {
        document.execCommand("InsertImage", false, src);
    };
    
    const insertOrderedList = function() {
        document.execCommand("insertOrderedList", false, null);
    };
    
    const insertUnorderedList = function() {
        document.execCommand("insertUnorderedList", false, null);
    };
    
    const toggleBold = function() {
        document.execCommand("bold", false, null);
    };
    
    const toggleItalic = function() {
        document.execCommand("italic", false, null);
    };
    
    const toggleStrikethrough = function() {
        document.execCommand("strikethrough", false, null);
    };
    
    const togglePlaceholder = function() {
        placeholder.style.display = isEmpty() ? "block" : "none";
    };
    
    const unlink = function() {
        document.execCommand("unlink", false, null);
    };
    
    const resetSelection = function() {
        if (selectedRange) {
            let selection = document.getSelection();
            selection.removeAllRanges();
            selection.addRange(selectedRange);
        }
    };
    
    const cacheSelection = function() {
        let selection = document.getSelection();
        if (selection && selection.rangeCount > 0) {
            selectedRange = selection.getRangeAt(0).cloneRange();
        } else {
            selectedRange = null;
        }
    };
    
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
    };
    
    const setHTML = function(html) {
        editor.innerHTML = html;
        togglePlaceholder();
    };
    
    const getHTML = function() {
        return editor.innerHTML;
    };
    
    const focusEditor = function() {
        editor.focus();
    };
    
    const isEmpty = function() {
        return editor.innerText.trim().length == 0;
    };
    
    const postMessage = function(message) {
        if (message == "selectionchange") {
            cacheSelection();
        }
        window.webkit.messageHandlers.\(name).postMessage(message);
    };

    window.addEventListener("load", function() {
        postMessage("load");
        togglePlaceholder();
    });
    
    document.addEventListener("selectionchange", function(event) {
        if (!muteSelectionchange) {
            togglePlaceholder();
            postMessage("selectionchange");
        }
    });
    
    editor.addEventListener("input", function() {
        togglePlaceholder();
        postMessage("input");
    });
    
    editor.addEventListener("paste", function() {
        postMessage("paste");
    });
    
    editor.addEventListener("click", function() {
        postMessage("click");
    });
    
    editor.addEventListener("focus", function() {
        resetSelection();
        isFocused = true;
        postMessage("focus");
    });
    
    editor.addEventListener("blur", function() {
        isFocused = false;
        postMessage("blur");
    });
    
    editor.addEventListener("touchstart", function() {
        muteSelectionchange = true;
    });
    
    editor.addEventListener("touchcancel", function() {
        muteSelectionchange = false;
        postMessage("selectionchange");
    });
    
    editor.addEventListener("touchend", function() {
        muteSelectionchange = false;
        postMessage("selectionchange");
    });
    
    editor.addEventListener("mousedown", function() {
        muteSelectionchange = true;
    });
    
    editor.addEventListener("mouseup", function() {
        selectionchangeMuted = false;
        postMessage("selectionchange");
    });
    
</script>
""" }
