import SwiftUI

public struct PushButtonStyle: ButtonStyle {
    public let isOn: Bool
    
    init(isOn: Bool, isDisabled: Bool = false) {
        self.isOn = isOn
        self.isDisabled = isDisabled
    }
    
    private let isDisabled: Bool
    
    // MARK: ButtonStyle
    public func makeBody(configuration: Self.Configuration) -> some View {
        ZStack {
            configuration.label
                .foregroundColor(isDisabled ? Color.secondary : .primary.opacity(0.92))
                .padding(EdgeInsets(top: 5.5, leading: 7.5, bottom: 5.5, trailing: 7.5))
        }
        .background(Color.secondary.opacity(isOn ? 0.4 : 0.0))
        .cornerRadius(5.5)
        .disabled(isDisabled)
    }
}

extension ButtonStyle where Self == PushButtonStyle {
    public static var push: Self {
        return push(isOn: false)
    }
    
    public static func push(isOn: Bool) -> Self {
        return Self(isOn: isOn)
    }
    
    static var disabledPush: Self {
        return Self(isOn: false, isDisabled: true)
    }
}

#Preview("Push Button Style") {
    HStack {
        Button(action: { }) {
            Image.format
        }
        .buttonStyle(.push(isOn: true))
        Button(action: { }) {
            Image.format
        }
        .buttonStyle(.push)
        Button(action: { }) {
            Image.format
        }
        .buttonStyle(.disabledPush)
    }
    .padding()
}
