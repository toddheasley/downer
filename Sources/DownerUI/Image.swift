import SwiftUI

extension Image {
    static var blur: Self { Self(systemName: "keyboard.chevron.compact.down.fill") }
    static var camera: Self { Self(systemName: "camera.fill") }
    static var files: Self { Self(systemName: "folder.fill") }
    static var format: Self { Self(systemName: "textformat") }
    static var photos: Self { Self(systemName: "photo.stack") }
    
    static func link(_ href: URL? = nil) -> Self {
        return Self(systemName: href != nil ? "link" : "link.badge.plus")
    }
    
    static func editor(_ action: Editor.Action, size: CGSize) -> some View {
        switch action {
        case .insertThemeBreak: // Swap symbol for shape
            return AnyView(ZStack(alignment: .top) {
                Rectangle()
                    .fill(.clear)
                    .frame(width: size.width, height: size.height)
                Self(action)
                        .resizable()
                        .frame(width: size.width, height: 2.5)
                }
                .accessibilityLabel(action.description))
        default:
            return AnyView(Self(action)
                .editor(size: size)
                .accessibilityLabel(action.description))
        }
    }
    
    func editor(_ contentMode: ContentMode? = .fit, size: CGSize) -> some View {
        return resizable()
            .aspectRatio(contentMode: contentMode)
            .frame(width: size.width, height: size.height)
    }
    
    init(_ action: Editor.Action) {
        switch action {
        case .createLink:
            self.init(systemName: "link.badge.plus")
        case .insertImage:
            self.init(systemName: "photo.badge.plus.fill")
        case .insertOrderedList:
            self.init(systemName: "list.number")
        case .insertUnorderedList:
            self.init(systemName: "list.bullet")
        case .toggleBold:
            self.init(systemName: "bold")
        case .toggleItalic:
            self.init(systemName: "italic")
        case .toggleStrikethrough:
            self.init(systemName: "strikethrough")
        case .createBlockquote:
            self.init("block.quote", bundle: .module)
        case .createHeading:
            self.init("heading", bundle: .module)
        case .insertCheckbox:
            self.init(systemName: "checklist")
        case .insertCodeBlock:
            self.init("code.block", bundle: .module)
        case .insertLineBreak:
            self.init(systemName: "return")
        case .insertTable:
            self.init(systemName: "tablecells")
        case .insertThemeBreak:
            self.init(systemName: "minus")
        case .toggleCode:
            self.init("code", bundle: .module)
        }
    }
}

#Preview("Image") {
    VStack {
        HStack {
            Image.format
                .editor(size: .small)
            VStack {
                Image.editor(.createLink(), size: .small)
                Image.link(URL(string: "/"))
                    .editor(size: .small)
                Image.link()
                    .editor(size: .small)
            }
            Image.editor(.insertImage(), size: .small)
            Image.blur
                .editor(size: .small)
        }
        .padding()
        VStack {
            HStack {
                Image.editor(.toggleBold, size: .small)
                Image.editor(.toggleItalic, size: .small)
                Image.editor(.toggleStrikethrough, size: .small)
                Image.editor(.toggleCode, size: .small)
            }
            HStack {
                Image.editor(.insertOrderedList, size: .medium)
                Image.editor(.insertUnorderedList, size: .medium)
                Image.editor(.insertCodeBlock, size: .medium)
            }
            HStack {
                Image.editor(.createBlockquote, size: .medium)
                Image.editor(.insertTable(), size: .medium)
                Image.editor(.insertCheckbox, size: .medium)
            }
            HStack(alignment: .top) {
                Image.editor(.insertThemeBreak, size: CGSize(width: 109.0, height: 8.0))
                Image.editor(.insertLineBreak, size: .small)
            }
            HStack(alignment: .bottom) {
                Image.editor(.createHeading(1), size: CGSize(65.0))
                Image.editor(.createHeading(2), size: CGSize(44.0))
            }
            HStack(alignment: .top) {
                Image.editor(.createHeading(3), size: CGSize(33.0))
                Image.editor(.createHeading(4), size: CGSize(24.0))
                Image.editor(.createHeading(5), size: CGSize(16.0))
                Image.editor(.createHeading(6), size: CGSize(12.0))
            }
        }
        .padding()
        HStack {
            Image.camera
                .editor(size: .small)
            Image.photos
                .editor(size: .small)
            Image.files
                .editor(size: .small)
        }
        .padding()
    }
    .padding()
}

private extension CGSize {
    static let medium: Self = Self(width: 44.0, height: 33.0)
    static let small: Self = Self(width: 31.0, height: 24.0)
    
    init(_ both: CGFloat) {
        self.init(width: both, height: both)
    }
}

private extension View {
    func aspectRatio(contentMode: ContentMode?) -> some View {
        guard let contentMode else {
            return AnyView(self)
        }
        return AnyView(aspectRatio(contentMode: contentMode))
    }
}
