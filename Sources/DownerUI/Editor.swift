import SwiftUI
import Downer

protocol EditorDelegate {
    
}

@Observable class Editor: CustomStringConvertible {
    var delegate: EditorDelegate?
    var baseURL: URL?
    
    func description(_ format: Format) -> String {
        return description
    }
    
    init(_ description: String = demo, baseURL: URL? = nil) {
        self.baseURL = baseURL
        self.description = description
    }
    
    // MARK: CustomStringConvertible
    var description: String {
        didSet {
            //print(description)
        }
    }
}

private let demo: String = """
<p>Test</p>
<h1>Welcome to the MarkupEditor Demo</h1>

<h6>Version 0.5</h6>

<p>The file you're looking at is just a simple HTML file that includes all the kinds of elements supported by the MarkupEditor by default. This document also serves as a brief tutorial on using the MarkupEditor as an end-user, along with some information for developers.</p>

<h2>Styles</h2>

<h4>Overall Document Styling</h4>

<p>When you load an HTML document into the MarkupEditor, the document is styled using <code>markup.css</code>. In this demo, you can use the <i>File</i> toolbar above to examine the raw HTML of this <code>demo.html</code> document. You will see it is "clean" in the sense that it contains no embedded attributes like style, font, or sizing. The overall document styling is up to you as a developer (and it's my intent to have it easily customizable).</p>

<h4>Paragraph Style</h4>

<p>This is a <i>Normal</i> style paragraph. The title above this paragraph uses an <i>H4</i> style. As you select in the text, the toolbar indicates the paragraph style of the element you selected.</p>

<p>A style applies to a block of text. The MarkupEditor supports the standard HTML styles of <i>P</i>, <i>H1</i>, <i>H2</i>, <i>H3</i>, <i>H4</i>, <i>H5</i>, and <i>H6</i>. Styles cannot contain other styles. So, for example, you can't embed an <i>H3</i> style in an <i>H1</i> style header.</p>

<p>The toolbar refers to <i>P</i> style as "Normal". The notion of a paragraph style is pretty well understood by every person who has ever used a word processor, spreadsheet, or even the most primitive text editing tool these days. Your users don't need to know anything about HTML or CSS just to use the MarkupEditor.</p>

<h4>Lists</h4>

<p>The MarkupEditor supports both numbered and bulleted style lists. They should behave like you would expect, maintaining the list style and progressing through the proper markers on sub-lists. You can switch styles using the toolbar and change styles within lists. Lists can contain tables and images, and the various paragraph styles can be applied within them.</p>

<ul>
    <li>
        <h5>Here is a bulleted list with an item in <i>H5</i> paragraph style.</h5>
        <ol>
            <li><p>Here is a numbered sublist.</p></li>
            <li><p>With two items.</p></li>
        </ol>
    </li>
    <li>
        <h5>The bulleted list has two items and a sublist that is numbered.</h5>
    </li>
</ul>

<h4>Indenting</h4>

<p>Like the other styles, indenting applies to a block of text, although you can indent both normal paragraphs and headers. Once you indent, the toolbar enables the outdent button. You can indent multiple times, and you can outdent until there is no more indenting to outdent. The hot-key combo ⌘] indents and ⌘[ outdents.</p>

<blockquote>
    <blockquote>
        <h5>Here is an example of a header that has been indented twice.</h5>
    </blockquote>
</blockquote>

<h2>Formats</h2>

<p>Text can be formatted to present as <b>bold</b>, <i>italic</i>, <u>underline</u>, <code>code</code>, and <del>strikethrough</del>. Unlike styles, formats can be combined; so for example, a <b><i><u>bold, italic, underlined</u></i></b> section of text works just fine.</p>

<p>Note that by default, the buttons to produce <sub>subscript</sub> and <sup>superscript</sup> formats are not shown in the toolbar and are not part of the Format menu on Mac. (This is also true of the undo and redo buttons, but they are always available via the Edit menu and the standard hot keys when you have a keyboard.) You can adjust the contents of the toolbar by specifying a custom <code>ToolbarContents</code>, as discussed in the MarkupEditor project's README.</p>

<h2>Inserted Elements</h2>

<p>You can insert and edit links, images, and tables in the document. Each of these elements requires some kind of user input to create them. The MarkupEditor presents either a popover at the selection location, or in the case of tables, a sub-toolbar at the MarkupEditor toolbar.</p>

<h4>Links</h4>

<p>To insert a <a href="https://github.com/stevengharris/MarkupEditor">link</a>, start by selecting some text to link-to. When you select the <i>Insert Link</i> button, a popover is presented at the selection location. Enter a URL and <i>Save</i> (or just hit Enter). <i>Cancel</i> closes the popover, leaving the original text/element unchanged. To delete an existing link, use the <i>Remove Link</i>.</p>

<h4>Images</h4>

<p>Images have to be inserted at a point in some text, or at the beginning or end of some text. You can paste-in an image using the usual Ctrl+V or the menu. You can also select an image from the file system or provide an URL. To do that, press the <i>Insert Image</i> button to bring up the image popover. Specify the URL or use the <i>Select</i> button for a standard file picker to select an image to insert. Specify additional descriptive text to go along with it (which is the right thing to do for people with visual impairment). As you tab between the URL and alt text fields, the MarkupEditor shows you the image in the document. Press OK when you are happy with the image, or Cancel to revert the document to its original state before you started inserting an image. Once you have the image in your document, you can resize it using the handles that show up when you select it, or using a pinch gesture on a touch device.</p>

<p>Here is an inline image sourced from the Internet: <!-- <img src="https://en.gravatar.com/userimage/34783542/290b5fe4078e031aef18e02c7bd9103f.png" alt="Linked image">. --> Select it and then press the image button to see its URL and alt text. Here is the same image, but sourced from the local file system relative in the same location as this document:</p>

<p><img src="steve.png" alt="Local image"></p>

<p>To delete an image, use the keyboard to delete it like text.</p>

<h4>Tables</h4>

<p>Tables have to be inserted between paragraphs, not inline with text. If you insert an image while you have selected a point inside of a paragraph, the table will be inserted after that paragraph. When you have the cursor at a point in text, press the <i>Insert Table</i> button to expose the table toolbar. The <i>Create</i> button on the left side lets you create a table with the number of rows and columns you want. Once you have created the table, or when you select a table in the document you're editing, the <i>Create</i> button is disabled. In other words, you cannot insert a table into a table.</p>

<p>The Add buttons in the table toolbar let you add a header at the top of the table or add rows/columns above/below the point you have selected in the table. The delete buttons remove the row/header you have selected in the table. To delete the header, select inside of it and press the delete row button. You can delete the table by backspacing over it, or using the <i>Delete</i> button in the toolbar.</p>

<p>Below is a simple two column table with a header. You can navigate forward using Tab (⇥) and backward using ⇧⇥. The header always spans across the table, with any text centered within it.</p>

<table>
    <thead>
        <tr>
            <th colspan="2"><p>The table header</p></th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><p>The table body</p></td>
            <td><p>with two columns</p</td>
        </tr>
    </tbody>
</table>

<p>You can change the table bordering using the buttons on the right side of the table toolbar. The default option is to put a border around all the individual cells, but you can just apply a border around the body and header (if there is one), or just to the outside of the entire table, or turn off bordering completely.</p>

<h2>Correction</h2>

<p>The <i>undo</i> and <i>redo</i> buttons should do what you expect and are also accessible via the menu and hot-keys (i.e., ⌘Z for undo and ⇧⌘Z for redo). For example, if you add a row to a table, undo will remove it. If you added a row, typed some text in a cell, and then added a column, three undos should get you back to where you started.</p>

<h2>Extending the MarkupEditor</h2>

<p>The File toolbar is part of the demo, but the <code>MarkupToolbar</code> itself does not include the <code>FileToolbar</code>. Check out the <code>DemoContentView</code> in <code>SwiftUIDemo</code> and <code>DemoViewController</code> in the <code>UIKitDemo</code> to see details of how it was done. The demo starts with some initial HTML taken from <code>demo.html</code>, which you are looking at and editing. You can open a different HTML file to see how it behaves. You can also toggle a view of the raw HTML off-and-on from the File toolbar. The raw HTML updates as you edit the document, to show what the MarkupEditor is doing behind the scenes. Note that normally (i.e., when using the MarkupEditor outside of the demo), typing is a very lightweight operation. Because the demo is set up to update the raw HTML as you type, it's a bit more heavyweight than usual.</p>

<p>The demo makes use of the <code>leftToolbar</code> option in the <code>MarkupEditor</code>, which makes it simple to add your own toolbar to the left (and/or with <code>rightToolbar</code> for the other side) of the standard <code>MarkupToolbar</code>. You can just as easily construct your own toolbar in SwiftUI using the toolbar-level views like <code>StyleToolbar</code> and <code>FormatToolbar</code>, or with the <code>LabeledToolbar</code> and <code>ToolbarButton</code> used within them.</p>
"""
