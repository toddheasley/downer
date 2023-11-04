import SwiftUI

public struct EditorToolbar: View {
    public init() {
        
    }
    
    @Environment(Editor.self) private var editor: Editor
    @Environment(\.colorScheme) private var colorScheme
    
    private var tint: Color {
        switch colorScheme {
        case .dark:
            return Color(white: 0.25, opacity: 0.99)
        default:
            return Color(red: 0.62, green: 0.64, blue: 0.69)
        }
    }
    
    private var opacity: Double {
        return editor.isFocused ? 1.0 : 0.0
    }
    
    // MARK: View
    public var body: some View {
        HStack {
#if canImport(UIKit)
            Group {
                FormatPicker()
                LinkPicker()
                ImagePicker()
                TablePicker()
            }
            .buttonStyle(.borderedProminent)
            .tint(tint)
            Spacer()
            BlurButton()
                .buttonStyle(.bordered)
                .foregroundColor(tint)
                .opacity(opacity)
#else
            FormatPicker()
            LinkPicker()
            ImagePicker()
            TablePicker()
#endif
        }
        .labelStyle(.iconOnly)
        .padding(.toolbar)
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
                Label("Format", systemImage: "textformat")
                    .frame(height: .height)
            }
            .popover("Format", isPresented: $isPresented) {
                Text("Popover")
            }
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
        @State private var text: String = ""
        
        private var systemImage: String {
            return link != nil ? "link" : "link.badge.plus"
        }
        
        private var link: Editor.Link? {
            return editor.state?.selection.link
        }
        
        // MARK: View
        var body: some View {
            Button(action: {
                isPresented.toggle()
            }) {
                Label("Link", systemImage: systemImage)
                    .frame(height: .height)
            }
            .keyboardShortcut("k", modifiers: .command)
            .popover("Link", isPresented: $isPresented) {
                TextField(text: $text, prompt: Text("URL"), label: {
                    Text("Add Link")
                })
            }
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
                Label("Image", systemImage: "photo.badge.plus.fill")
                    .frame(height: .height)
            }
            .popover("Image", isPresented: $isPresented) {
                EmptyView()
            }
            .disabled(true)
        }
    }
}

#Preview("Image Picker") {
    EditorToolbar.ImagePicker()
        .environment(Editor())
        .padding()
}

extension EditorToolbar {
    struct TablePicker: View {
        @Environment(Editor.self) private var editor: Editor
        @State private var isPresented: Bool = false
        
        // MARK: View
        var body: some View {
            Button(action: {
                isPresented.toggle()
            }) {
                Label("Table", systemImage: "tablecells")
                    .frame(height: .height)
            }
            .popover("Table", isPresented: $isPresented) {
                EmptyView()
            }
            .disabled(true)
        }
    }
}

#Preview("Image Picker") {
    EditorToolbar.TablePicker()
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
                Label("Done", systemImage: "keyboard.chevron.compact.down.fill")
                    .frame(height: .height)
            }
        }
    }
}

#Preview("Blur Button") {
    EditorToolbar.BlurButton()
        .environment(Editor())
        .padding()
}

private extension CGFloat {
    static var height: Self {
#if canImport(UIKit)
        return 19.0
#else
        return 19.0
#endif
    }
}
