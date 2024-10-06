#if !os(watchOS) && !os(tvOS)
import SwiftUI

public struct EditorToolbar: View {
    public init() { }
    
    @Environment(Editor.self) private var editor: Editor
    
    private var opacity: Double { editor.isFocused ? 1.0 : 0.0 }
    
    // MARK: View
    public var body: some View {
        HStack {
#if canImport(UIKit)
            Group {
                FormatPicker()
                LinkPicker()
                ImagePicker()
            }
            .buttonStyle(.borderedProminent)
            Spacer()
            BlurButton()
                .buttonStyle(.bordered)
                .opacity(opacity)
#else
            FormatPicker()
            LinkPicker()
            ImagePicker()
#endif
        }
        .labelStyle(.iconOnly)
        .padding(.leading, EdgeInsets.default.leading)
        .padding(.trailing, EdgeInsets.default.trailing)
        .padding(.vertical, .spacing)
    }
}

#Preview("Editor Toolbar") {
    EditorToolbar()
        .environment(Editor())
}

extension EditorToolbar {
    struct FormatPicker: View {
        @Environment(Editor.self) private var editor: Editor
        @State private var isPresented: Bool = false
        
        // MARK: View
        var body: some View {
            Button(action: {
                isPresented.toggle()
            }) {
                Image.format
                    .editor(size: CGSize(width: 21.0))
                    .padding(.horizontal, 3.0)
            }
            .popover("Format", isPresented: $isPresented) {
                FormatMenu(isPresented: $isPresented)
            }
            .accessibilityLabel("Format")
            .disabled(!(editor.isFocused || isPresented))
        }
    }
}

#Preview("Format Picker") {
    EditorToolbar.FormatPicker()
        .environment(Editor())
        .padding()
}

extension EditorToolbar {
    struct LinkPicker: View {
        @Environment(Editor.self) private var editor: Editor
        @State private var isPresented: Bool = false
        
        // MARK: View
        var body: some View {
            Button(action: {
                isPresented.toggle()
            }) {
                Image.link(editor.state?.selection.link?.href)
                    .editor(size: CGSize(width: 27.0))
            }
            .keyboardShortcut("k", modifiers: .command)
            .popover("Link", isPresented: $isPresented) {
                LinkMenu(isPresented: $isPresented)
            }
            .accessibilityLabel("Link")
            .disabled(!(editor.isFocused || isPresented))
        }
    }
}

#Preview("Link Picker") {
    EditorToolbar.LinkPicker()
        .environment(Editor())
        .padding()
}

extension EditorToolbar {
    struct ImagePicker: View {
        @Environment(Editor.self) private var editor: Editor
        @State private var isPresented: Bool = false
        
        // MARK: View
        var body: some View {
            Button(action: {
                isPresented.toggle()
            }) {
                Image.editor(.insertImage(), size: CGSize(width: 27.0))
            }
            .popover("Image", isPresented: $isPresented) {
                ImageMenu(isPresented: $isPresented)
            }
            .accessibilityLabel("Image")
            .disabled(!(editor.isFocused || isPresented))
        }
    }
}

#Preview("Image Picker") {
    EditorToolbar.ImagePicker()
        .environment(Editor())
        .padding()
}

extension EditorToolbar {
    struct BlurButton: View {
        @Environment(Editor.self) private var editor: Editor
        
        // MARK: View
        var body: some View {
            Button(action: {
                editor.blur()
            }) {
                Image.blur
                    .editor(size: CGSize(width: 27.0))
            }
            .accessibilityLabel("Done")
            .foregroundColor(.secondary)
        }
    }
}

#Preview("Blur Button") {
    EditorToolbar.BlurButton()
        .environment(Editor())
        .padding()
}

private extension CGSize {
    init(width: CGFloat) {
        #if canImport(Cocoa)
        self.init(width: width * 0.8, height: 21.0)
        #else
        self.init(width: width, height: 19.0)
        #endif
    }
}
#endif
