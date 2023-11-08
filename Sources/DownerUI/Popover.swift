import SwiftUI

extension View {
    func popover<Content: View>(_ title: String, isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        popover(isPresented: isPresented) {
            Popover(title, isPresented: isPresented, content: content)
                .frame(minWidth: 192.0, maxWidth: 384.0)
                .presentationCompactAdaptation(.popover)
        }
    }
}

struct Popover<Content: View>: View {
    let content: () -> Content
    let title: String
    
    init(_ title: String = "", isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.title = title
        _isPresented = isPresented
    }
    
    @Binding private var isPresented: Bool
    
    // MARK: View
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.system(.title2, weight: .semibold))
                    .padding(.leading, 4.5)
                Spacer()
                CloseButton {
                    isPresented.toggle()
                }
            }
            .padding(.popover)
            content()
        }
#if os(macOS)
        .onExitCommand {
            isPresented.toggle()
        }
#endif
    }
}

#Preview("Popover") {
    Popover("Popover", isPresented: .constant(true)) {
        EmptyView()
    }
}
