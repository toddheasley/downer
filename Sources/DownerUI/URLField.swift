#if !os(watchOS) && !os(tvOS)
import SwiftUI
import Downer

struct URLField: View {
    let prompt: String?
    
    init(_ url: Binding<URL?>, prompt: String? = nil, focus: Bool = false) {
        self.prompt = prompt
        self.focus = focus
        _url = url
    }
    
    @Binding private var url: URL?
    @FocusState private var isFocused: Bool
    @State private var text: String = ""
    private let focus: Bool
    
    // MARK: View
    var body: some View {
        TextField("URL", text: $text, prompt: Text(prompt))
            .textFieldStyle(.roundedBorder)
#if os(iOS)
            .textInputAutocapitalization(.never)
            .keyboardType(.URL)
#endif
            .focused($isFocused)
            .onChange(of: text, initial: true) {
                url = URL(string: text.trimmingCharacters(in: .whitespacesAndNewlines))
            }
            .onAppear {
                guard focus else { return }
                isFocused = true
            }
    }
}

#Preview("URL Field") {
    URLField(.constant(nil), prompt: "URL (or file path)")
        .padding()
}

private extension SwiftUI.Text {
    init?(_ prompt: String?) {
        guard let prompt else { return nil }
        self = Self(prompt)
    }
}
#endif
