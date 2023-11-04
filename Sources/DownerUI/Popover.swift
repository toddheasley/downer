import SwiftUI

extension View {
    func popover<Content: View>(_ title: String, isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        popover(isPresented: isPresented) {
            Popover(title, isPresented: isPresented, content: content)
                .frame(minWidth: 180.0)
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
                Spacer()
                CloseButton {
                    isPresented.toggle()
                }
            }
            content()
        }
        .padding(.popover)
    }
}

#Preview("Popover") {
    Popover("Popover", isPresented: .constant(true)) {
        EmptyView()
    }
}
