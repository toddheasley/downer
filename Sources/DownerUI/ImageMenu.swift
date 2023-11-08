import SwiftUI

struct ImageMenu: View {
    @Environment(Editor.self) private var editor: Editor
    @Binding private var isPresented: Bool
    @State private var url: URL?
    
    init(isPresented: Binding<Bool> = .constant(false)) {
        _isPresented = isPresented
    }
    
    private func blur() {
        isPresented.toggle()
        editor.blur()
    }
    
    // MARK: View
    var body: some View {
        VStack(spacing: .spacing) {
            
            URLField($url, focus: true)
            HStack {
                Spacer()
                Button(action: {
                    ()
                }) {
                    Text("Insert Image")
                }
                .buttonStyle(.bordered)
                .disabled(url == nil)
            }
        }
        .onSubmit {
            blur()
        }
        .padding(.popover)
        .frame(minWidth: 256.0, idealWidth: 320.0, maxWidth: 384.0)
    }
}

#Preview("Image Menu") {
    ImageMenu()
        .environment(Editor())
}
