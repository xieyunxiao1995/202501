import SwiftUI
import UIKit

enum AppTheme {
    static let navy = Color(red: 0.043, green: 0.078, blue: 0.145)
    static let panel = Color(red: 0.082, green: 0.133, blue: 0.212)
    static let elevated = Color(red: 0.105, green: 0.172, blue: 0.258)
    static let yellow = Color(red: 1.0, green: 0.75, blue: 0.27)
    static let grass = Color(red: 0.33, green: 0.73, blue: 0.51)
    static let shadow = Color(red: 0.12, green: 0.24, blue: 0.37)
    static let textMuted = Color(red: 0.59, green: 0.68, blue: 0.75)
}

struct Surface<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            content
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.panel, in: RoundedRectangle(cornerRadius: 18))
    }
}

struct MetricView: View {
    let label: String
    let value: String
    let symbol: String
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: symbol).foregroundStyle(AppTheme.yellow)
                Spacer(minLength: 4)
            }
            Text(value).font(.system(.title2, design: .rounded, weight: .semibold))
                .minimumScaleFactor(0.6).lineLimit(1)
            Text(label).font(.caption).foregroundStyle(AppTheme.textMuted)
                .lineLimit(2).minimumScaleFactor(0.7)
        }
        .padding(12).frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.panel, in: RoundedRectangle(cornerRadius: 14))
    }
}

/// Installs a non-cancelling window tap recognizer while the form is presented.
/// Taps inside text input controls are ignored; tapping any other region dismisses the keyboard.
private final class KeyboardDismissAnchor: UIView {
    var windowDidChange: ((UIWindow?) -> Void)?
    override func didMoveToWindow() {
        super.didMoveToWindow()
        windowDidChange?(window)
    }
}

private struct KeyboardDismissInstaller: UIViewRepresentable {
    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        private weak var attachedWindow: UIWindow?
        private var recognizer: UITapGestureRecognizer?

        func install(on window: UIWindow?) {
            if attachedWindow === window { return }
            remove()
            guard let window else { return }
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
            tap.cancelsTouchesInView = false
            tap.delegate = self
            window.addGestureRecognizer(tap)
            attachedWindow = window
            recognizer = tap
        }
        func remove() {
            if let recognizer { attachedWindow?.removeGestureRecognizer(recognizer) }
            recognizer = nil
            attachedWindow = nil
        }
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                               shouldReceive touch: UITouch) -> Bool {
            var current = touch.view
            while let view = current {
                if view is UITextField || view is UITextView || view is UISearchBar {
                    return false
                }
                current = view.superview
            }
            return true
        }
        @objc private func dismiss() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                            to: nil, from: nil, for: nil)
        }
    }
    func makeCoordinator() -> Coordinator { Coordinator() }
    func makeUIView(context: Context) -> KeyboardDismissAnchor {
        let view = KeyboardDismissAnchor(frame: .zero)
        view.isUserInteractionEnabled = false
        view.windowDidChange = { [weak coordinator = context.coordinator] window in
            coordinator?.install(on: window)
        }
        return view
    }
    func updateUIView(_ uiView: KeyboardDismissAnchor, context: Context) {}
    static func dismantleUIView(_ uiView: KeyboardDismissAnchor, coordinator: Coordinator) {
        coordinator.remove()
    }
}

extension View {
    func dismissKeyboardOnTap() -> some View {
        background(KeyboardDismissInstaller().frame(width: 0, height: 0))
    }
}
