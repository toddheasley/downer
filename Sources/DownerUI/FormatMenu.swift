#if !os(watchOS) && !os(tvOS)
import SwiftUI

struct FormatMenu: View {
    @Environment(Editor.self) private var editor: Editor
    @Binding private var isPresented: Bool
    
    init(isPresented: Binding<Bool> = .constant(false)) {
        _isPresented = isPresented
    }
    
    private func exec(_ action: Editor.Action?) {
        if let action {
            editor.exec(action)
        }
        isPresented.toggle()
        editor.focus()
    }
    
    // MARK: View
    var body: some View {
        VStack(spacing: .spacing) {
            HStack {
                Button(action: {
                    exec(.toggleBold)
                }) {
                    Image.editor(.toggleBold, size: .small)
                }
                .buttonStyle(.push(isOn: editor.isOn("B")))
                Button(action: {
                    exec(.toggleItalic)
                }) {
                    Image.editor(.toggleItalic, size: .small)
                }
                .buttonStyle(.push(isOn: editor.isOn("I")))
                Button(action: {
                    exec(.toggleStrikethrough)
                }) {
                    Image.editor(.toggleStrikethrough, size: .small)
                }
                .buttonStyle(.push(isOn: editor.isOn("STRIKE")))
                Button(action: {
                    exec(.toggleCode)
                }) {
                    Image.editor(.toggleCode, size: .small)
                }
                // .buttonStyle(.push(isOn: editor.isOn("CODE"))
                .buttonStyle(.disabledPush)
            }
            .padding(.top, EdgeInsets.popover.top * 0.5)
            HStack(spacing: .spacing) {
                Button(action: {
                    exec(.insertOrderedList)
                }) {
                    Image.editor(.insertOrderedList, size: .medium)
                }
                .buttonStyle(.push(isOn: editor.isOn("OL")))
                Button(action: {
                    exec(.insertUnorderedList)
                }) {
                    Image.editor(.insertUnorderedList, size: .medium)
                }
                .buttonStyle(.push(isOn: editor.isOn("UL")))
                Button(action: {
                    exec(.insertCodeBlock)
                }) {
                    Image.editor(.insertCodeBlock, size: .medium)
                }
                .buttonStyle(.disabledPush)
            }
            HStack(spacing: .spacing) {
                Button(action: {
                    exec(.createBlockquote)
                }) {
                    Image.editor(.createBlockquote, size: .medium)
                }
                .buttonStyle(.disabledPush)
                Button(action: {
                    exec(.insertTable())
                }) {
                    Image.editor(.insertTable(), size: .medium)
                }
                .buttonStyle(.disabledPush)
                Button(action: {
                    exec(.insertCheckbox)
                }) {
                    Image.editor(.insertCheckbox, size: .medium)
                }
                .buttonStyle(.disabledPush)
            }
            HStack(alignment: .top, spacing: .spacing) {
                Button(action: {
                    exec(.insertThemeBreak)
                }) {
                    Image.editor(.insertThemeBreak, size: CGSize(width: 128.0, height: 3.0))
                }
                .buttonStyle(.disabledPush)
                Button(action: {
                    exec(.insertLineBreak)
                }) {
                    Image.editor(.insertLineBreak, size: .small)
                }
                .buttonStyle(.disabledPush)
            }
            .padding(.bottom, -27.0)
            ScrollView(.horizontal) {
                HStack(alignment: .bottom, spacing: .spacing) {
                    Button(action: {
                        exec(.createHeading(1))
                    }) {
                        Image.editor(.createHeading(1), size: CGSize(width: 56.0, height: 63.0))
                    }
                    .buttonStyle(.disabledPush)
                    Button(action: {
                        exec(.createHeading(2))
                    }) {
                        Image.editor(.createHeading(2), size: CGSize(width: 41.0, height: 48.0))
                    }
                    .buttonStyle(.disabledPush)
                    Button(action: {
                        exec(.createHeading(3))
                    }) {
                        Image.editor(.createHeading(3), size: CGSize(width: 35.0, height: 39.0))
                    }
                    .buttonStyle(.disabledPush)
                    Button(action: {
                        exec(.createHeading(4))
                    }) {
                        Image.editor(.createHeading(4), size: CGSize(width: 26.5, height: 31.0))
                    }
                    .buttonStyle(.disabledPush)
                    Button(action: {
                        exec(.createHeading(5))
                    }) {
                        Image.editor(.createHeading(5), size: CGSize(width: 17.5, height: 22.0))
                    }
                    .buttonStyle(.disabledPush)
                    Button(action: {
                        exec(.createHeading(6))
                    }) {
                        Image.editor(.createHeading(6), size: CGSize(width: 12.0, height: 16.0))
                    }
                    .buttonStyle(.disabledPush)
                }
                .padding(.popover)
                
            }
            .scrollIndicators(.hidden)
        }
        .frame(width: 216.0)
    }
}

#Preview("Format Menu") {
    FormatMenu()
        .environment(Editor())
}

private extension Editor {
    func isOn(_ nodeName: String?) -> Bool {
        nodeName == state?.selection.nodeName
    }
}

private extension CGSize {
    static let medium: Self = Self(width: 44.0, height: 36.0)
    static let small: Self = Self(width: 27.0, height: 19.0)
}
#endif
