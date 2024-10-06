#if !os(watchOS) && !os(tvOS)
import SwiftUI

struct LinkMenu: View {
    @Environment(Editor.self) private var editor: Editor
    @Binding private var isPresented: Bool
    @State private var url: URL?
    
    init(isPresented: Binding<Bool> = .constant(false)) {
        _isPresented = isPresented
    }
    
    private var text: String { editor.state?.selection.text ?? "" }
    
    private var link: Editor.Link? { editor.state?.selection.link }
    
    private func toggleLink() {
        if link != nil {
            // editor.exec(.unlink)
        } else {
            editor.exec(.createLink(url))
        }
        isPresented.toggle()
        editor.focus()
    }
    
    // MARK: View
    var body: some View {
        VStack(spacing: .spacing) {
            if !text.isEmpty {
                Text("\"\(text)\"")
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            if let link {
                URLField(.constant(link.href))
                HStack {
                    Spacer()
                    Button(action: {
                        toggleLink()
                    }) {
                        Text("Remove Link")
                    }
                    .buttonStyle(.bordered)
                }
            } else {
                URLField($url, focus: true)
                HStack {
                    Spacer()
                    Button(action: {
                        toggleLink()
                    }) {
                        Text("Add Link")
                    }
                    .buttonStyle(.bordered)
                    .disabled(url == nil)
                }
            }
        }
        .onSubmit {
            toggleLink()
        }
        .padding(.popover)
        .frame(minWidth: 256.0, idealWidth: 320.0, maxWidth: 384.0)
    }
}

#Preview("Link Menu") {
    LinkMenu()
        .environment(Editor())
}
#endif
