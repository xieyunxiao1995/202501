import PhotosUI
import SwiftUI
import UniformTypeIdentifiers

// iOS 15/16 上没有的系统接口在这里统一兼容：新系统照用原组件，旧系统用效果接近的替代实现。

extension View {
    /// onChange 只给新值：iOS 17 起用新接口，旧系统用 onChange(of:perform:)。
    @ViewBuilder
    func onChangeCompat<V: Equatable>(of value: V, perform action: @escaping (V) -> Void) -> some View {
        if #available(iOS 17, *) {
            onChange(of: value) { _, new in action(new) }
        } else {
            onChange(of: value, perform: action)
        }
    }

    /// 隐藏导航栏：toolbar(.hidden, for:) 要 iOS 16。
    @ViewBuilder
    func navigationBarHiddenCompat() -> some View {
        if #available(iOS 16, *) {
            toolbar(.hidden, for: .navigationBar)
        } else {
            navigationBarHidden(true)
        }
    }

    /// 滚动时收起键盘：scrollDismissesKeyboard 要 iOS 16，旧系统不处理。
    @ViewBuilder
    func scrollDismissesKeyboardCompat() -> some View {
        if #available(iOS 16, *) {
            scrollDismissesKeyboard(.interactively)
        } else {
            self
        }
    }

    /// 文字替换时淡入淡出：contentTransition 要 iOS 16，旧系统直接替换。
    @ViewBuilder
    func opacityTransitionCompat() -> some View {
        if #available(iOS 16, *) {
            contentTransition(.opacity)
        } else {
            self
        }
    }

    /// 倒计时数字滚动：numericText 要 iOS 16，旧系统直接替换。
    @ViewBuilder
    func countdownTransitionCompat(reduceMotion: Bool) -> some View {
        if #available(iOS 16, *), !reduceMotion {
            contentTransition(.numericText(countsDown: true))
        } else {
            self
        }
    }
}

/// NavigationStack 要 iOS 16，旧系统用单栏 NavigationView。
struct NavigationStackCompat<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        if #available(iOS 16, *) {
            NavigationStack { content }
        } else {
            NavigationView { content }.navigationViewStyle(.stack)
        }
    }
}

/// ViewThatFits(in: .horizontal) 要 iOS 16：旧系统直接用备选（竖排）布局。
struct HorizontalFit<Preferred: View, Fallback: View>: View {
    @ViewBuilder var preferred: Preferred
    @ViewBuilder var fallback: Fallback

    var body: some View {
        if #available(iOS 16, *) {
            ViewThatFits(in: .horizontal) {
                preferred
                fallback
            }
        } else {
            fallback
        }
    }
}

/// 宽屏横排、窄屏竖排。AnyLayout 要 iOS 16，旧系统用 HStack/VStack 切换。
struct AdaptiveStack<Content: View>: View {
    let wide: Bool
    let wideSpacing: CGFloat
    let narrowSpacing: CGFloat
    @ViewBuilder var content: Content

    var body: some View {
        if #available(iOS 16, *) {
            let layout = wide ? AnyLayout(HStackLayout(alignment: .top, spacing: wideSpacing)) :
                AnyLayout(VStackLayout(alignment: .leading, spacing: narrowSpacing))
            layout { content }
        } else if wide {
            HStack(alignment: .top, spacing: wideSpacing) { content }
        } else {
            VStack(alignment: .leading, spacing: narrowSpacing) { content }
        }
    }
}

/// LabeledContent 要 iOS 16：旧系统左侧标题、右侧灰色值。
struct LabeledValue<Label: View, Content: View>: View {
    @ViewBuilder var content: Content
    @ViewBuilder var label: Label

    var body: some View {
        if #available(iOS 16, *) {
            LabeledContent { content } label: { label }
        } else {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 2) { label }
                Spacer(minLength: 12)
                content.foregroundStyle(.secondary).multilineTextAlignment(.trailing)
            }
        }
    }
}

extension LabeledValue where Label == Text, Content == Text {
    init(_ title: String, value: String) {
        self.init { Text(value) } label: { Text(title) }
    }
}

/// ContentUnavailableView 要 iOS 17：旧系统用居中的图标、标题、说明和操作。
struct EmptyStateView<Actions: View>: View {
    let title: String
    let systemImage: String
    var message: String?
    @ViewBuilder var actions: Actions

    var body: some View {
        if #available(iOS 17, *) {
            ContentUnavailableView {
                Label(title, systemImage: systemImage)
            } description: {
                if let message { Text(message) }
            } actions: {
                actions
            }
        } else {
            VStack(spacing: 12) {
                Image(systemName: systemImage)
                    .font(.system(size: 44))
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)
                Text(title).font(.title2.weight(.bold)).multilineTextAlignment(.center)
                if let message {
                    Text(message).font(.subheadline).foregroundStyle(.secondary).multilineTextAlignment(.center)
                }
                actions
            }
            .padding(.vertical, 32)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
        }
    }
}

extension EmptyStateView where Actions == EmptyView {
    init(title: String, systemImage: String, message: String? = nil) {
        self.init(title: title, systemImage: systemImage, message: message) { EmptyView() }
    }
}

/// ShareLink 要 iOS 16：旧系统点按钮弹出系统分享面板。
struct ShareButton<Label: View>: View {
    private let text: String?
    private let url: URL?
    private let label: Label
    @State private var sharing = false

    init(text: String, @ViewBuilder label: () -> Label) {
        self.text = text
        url = nil
        self.label = label()
    }

    init(url: URL, @ViewBuilder label: () -> Label) {
        text = nil
        self.url = url
        self.label = label()
    }

    var body: some View {
        if #available(iOS 16, *) {
            if let url { ShareLink(item: url) { label } }
            else { ShareLink(item: text ?? "") { label } }
        } else {
            Button { sharing = true } label: { label }
                .sheet(isPresented: $sharing) {
                    ActivitySheet(items: [url.map { $0 as Any } ?? (text ?? "") as Any])
                }
        }
    }
}

private struct ActivitySheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ controller: UIActivityViewController, context: Context) {}
}

/// 选中的照片。PhotosPicker 要 iOS 16，各系统统一用 PHPicker。
struct PickedPhoto: Equatable {
    let id = UUID()
    let provider: NSItemProvider

    static func == (lhs: PickedPhoto, rhs: PickedPhoto) -> Bool { lhs.id == rhs.id }

    /// 读出图片原始数据（与 PhotosPicker 的 loadTransferable(type: Data.self) 一致）。
    @MainActor func loadData() async -> Data? {
        await withCheckedContinuation { continuation in
            _ = provider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, _ in
                continuation.resume(returning: data)
            }
        }
    }
}

/// 系统照片选择器，只选一张图片。
struct PhotoPicker: UIViewControllerRepresentable {
    let onPick: (PickedPhoto?) -> Void

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ controller: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(onPick: onPick) }

    final class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let onPick: (PickedPhoto?) -> Void

        init(onPick: @escaping (PickedPhoto?) -> Void) { self.onPick = onPick }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            onPick(results.first.map { PickedPhoto(provider: $0.itemProvider) })
        }
    }
}

extension Task where Success == Never, Failure == Never {
    /// Task.sleep(for:) 要 iOS 16。
    static func sleep(seconds: Double) async throws {
        try await sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}

extension Locale {
    /// Locale.language 要 iOS 16。
    var languageCodeCompat: String? {
        if #available(iOS 16, *) { return language.languageCode?.identifier }
        return languageCode
    }
}
