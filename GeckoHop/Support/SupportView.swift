import PhotosUI
import SwiftUI

struct SupportView: View {
    @AppLocalized private var L
    @Environment(\.colorScheme) private var colorScheme
    @FocusState private var draftFocused: Bool
    @ObservedObject var model: AppModel
    let diagnosticsOnOpen: Bool
    @State private var messages: [SupportMessage] = []
    @State private var conversation = "none"
    @State private var contact = ""
    @State private var draft = ""
    @State private var photo: PickedPhoto?
    @State private var choosingPhoto = false
    @State private var imageData: Data?
    @State private var imageFields: [String: Any]?
    @State private var pending: [String: Any]?
    @State private var pendingIdentity: SupportIdentity?
    @State private var error: String?
    @State private var sending = false
    @State private var loading = false
    @State private var more = true
    @State private var captcha = false
    @State private var visitor = false
    @State private var showDiagnostics = false
    @State private var askedDiagnostics = false
    @State private var showFeedbackThanks = false

    private var signedIn: Bool { model.session != nil }
    private var available: Bool { signedIn || visitor }
    private var canSend: Bool {
        !sending && (photo == nil || imageData != nil)
            && (imageData != nil || !draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }

    var body: some View {
        Group {
            if available {
                ScrollViewReader { scroll in
                    List {
                        if !signedIn {
                            Section {
                                NavigationLink(contact.isEmpty ? L("绑定联系邮箱", "Link contact email") : contact) {
                                    SupportContactView(model: model, contact: $contact)
                                }
                            }
                        }
                        Section {
                            if more, !messages.isEmpty {
                                Button(L("查看较早记录", "Show conversation history")) { Task { await reload(earlier: true) } }
                                    .frame(minHeight: 44)
                                    .disabled(loading)
                            }
                            if messages.isEmpty {
                                EmptyStateView(title: L("描述你遇到的问题。", "Tell us what happened."),
                                               systemImage: "bubble.left.and.bubble.right")
                                .listRowSeparator(.hidden)
                            }
                            ForEach(messages) { message in
                                messageRow(message)
                                    .listRowSeparator(.hidden)
                            }
                            if conversation == "ai", let last = messages.last, last.sender == "user",
                               let sent = last.createdAt, Date.now.timeIntervalSince1970 - sent < 60 {
                                Text(L("GeckConnent_Bot 正在回复…", "GeckConnent_Bot is replying…"))
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                    .listRowSeparator(.hidden)
                            }
                            if let error {
                                StatusBanner(tone: .failure, message: error)
                                    .id("support.error")
                                    .listRowSeparator(.hidden)
                            }
                        } header: {
                            Text(status)
                        }
                    }
                    .listStyle(.plain)
                    .scrollDismissesKeyboardCompat()
                    .onChangeCompat(of: messages.last?.seq) { latest in
                        if let latest { scroll.scrollTo(latest, anchor: .bottom) }
                    }
                    .onChangeCompat(of: error) { value in
                        if value != nil { scroll.scrollTo("support.error", anchor: .bottom) }
                    }
                }
                .frame(maxWidth: 640)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .simultaneousGesture(TapGesture().onEnded { draftFocused = false })
                .refreshable { await reload() }
                .safeAreaInset(edge: .bottom, spacing: 0) { composer }
            } else {
                EmptyStateView(title: L("联系 GeckConnent 客服", "Contact GeckConnent support"), systemImage: "lifepreserver",
                               message: L("验证后即可发消息。", "Complete a security check to send a message.")) {
                    Button(L("继续", "Continue")) { captcha = true }.buttonStyle(.borderedProminent)
                    if let error { StatusBanner(tone: .warning, message: error) }
                }
            }
        }
        .navigationTitle(L("客服", "Support"))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $captcha) {
            CaptchaView(api: model.api, email: "", purpose: "visitor") { ticket in
                try await model.createVisitor(ticket)
                visitor = true
                error = nil
            }
        }
        .task { visitor = model.visitorToken != nil }
        .task(id: signedIn ? model.session?.user.uuid : (visitor ? "visitor" : nil)) {
            messages = []
            draft = ""
            photo = nil
            imageData = nil
            imageFields = nil
            pending = nil
            pendingIdentity = nil
            more = true
            contact = ""
            conversation = "none"
            guard available else { return }
            if diagnosticsOnOpen, !askedDiagnostics {
                askedDiagnostics = true
                showDiagnostics = true
            }
            while !Task.isCancelled {
                await reload()
                do { try await Task.sleep(seconds: 5) } catch { break }
            }
        }
        .sheet(isPresented: $choosingPhoto) {
            PhotoPicker { picked in
                choosingPhoto = false
                if let picked {
                    imageData = nil
                    imageFields = nil
                    photo = picked
                }
            }
            .ignoresSafeArea()
        }
        .task(id: photo?.id) {
            guard let photo else { return }
            do {
                let data = await photo.loadData()
                guard !Task.isCancelled, self.photo == photo else { return }
                imageData = data
                imageFields = nil
                if data == nil { throw APIError(code: "invalid_image") }
            } catch { if !Task.isCancelled { self.error = error.localizedDescription } }
        }
        .confirmationDialog(L("发送连接诊断？", "Send connection diagnostics?"), isPresented: $showDiagnostics, titleVisibility: .visible) {
            Button(L("发送给客服", "Send to support")) { Task { await send(diagnostics: true) } }
        } message: {
            Text(L("包含系统版本、线路、连接状态和近期错误。", "Includes system version, route, connection status, and recent errors."))
        }
        .alert(L("感谢你的反馈", "Thank you for your feedback"), isPresented: $showFeedbackThanks) {
            Button(L("知道了", "OK"), role: .cancel) {}
        } message: {
            Text(L("可在客服会话中查看发送状态。", "Check the support conversation for message status."))
        }
    }

    private var status: String {
        switch conversation {
        case "ai": L("智能客服", "Automated support")
        case "human": L("人工处理中", "Human support")
        case "closed": L("会话已结束", "Conversation closed")
        default: L("消息", "Messages")
        }
    }

    private var composer: some View {
        let photoPickerTitle = L("选择照片", "Choose a photo")
        return VStack(alignment: .leading, spacing: 6) {
            if imageData != nil {
                Button(L("撤下这张照片", "Remove this photo")) {
                    draftFocused = false
                    photo = nil
                    imageData = nil
                    imageFields = nil
                }
                .frame(minHeight: 44)
                .disabled(pending != nil || sending)
            }
            if pending != nil {
                HorizontalFit {
                    HStack(spacing: 8) {
                        retryButtons
                    }
                    .fixedSize(horizontal: true, vertical: false)
                } fallback: {
                    VStack(alignment: .leading, spacing: 4) {
                        retryButtons
                    }
                }
                .disabled(sending)
            } else {
                let prompt = L("写一条消息", "Write a message")
                draftField(prompt)
                    .focused($draftFocused)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .frame(minHeight: 44)
                    .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
                    .accessibilityIdentifier("support.draft")
                    .disabled(sending)
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Button {
                            draftFocused = false
                            choosingPhoto = true
                        } label: {
                            Label(photoPickerTitle, systemImage: "paperclip")
                                .frame(width: 44, height: 44)
                                .contentShape(Rectangle())
                        }
                        Button {
                            draftFocused = false
                            showDiagnostics = true
                        } label: {
                            Label(L("附上连接报告", "Attach a connection report"), systemImage: "stethoscope")
                                .frame(width: 44, height: 44)
                                .contentShape(Rectangle())
                        }
                    }
                    .font(.title3)
                    .labelStyle(.iconOnly)
                    .buttonStyle(.plain)
                    Spacer(minLength: 0)
                    Button {
                        draftFocused = false
                        showFeedbackThanks = true
                        Task { await send() }
                    } label: {
                        Text(L("发送", "Send"))
                            .font(.body.weight(.semibold))
                            .frame(minWidth: 54, minHeight: 44)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(colorScheme == .dark ? Palette.signal : Palette.panel)
                    .foregroundStyle(canSend ? (colorScheme == .dark ? Palette.ink : .white) : .secondary)
                    .disabled(!canSend)
                }.disabled(sending)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .frame(maxWidth: 640, alignment: .leading)
        .frame(maxWidth: .infinity)
        .background {
            Rectangle()
                .fill(.background)
                .onTapGesture { draftFocused = false }
        }
        .overlay(alignment: .top) { Divider() }
    }

    /// 多行输入（axis: .vertical）要 iOS 16，旧系统用单行输入框。
    @ViewBuilder private func draftField(_ prompt: String) -> some View {
        let placeholder = Text(prompt).foregroundColor(Color.primary.opacity(0.68))
        if #available(iOS 16, *) {
            TextField(prompt, text: $draft, prompt: placeholder, axis: .vertical)
                .lineLimit(1...4)
        } else {
            TextField(prompt, text: $draft, prompt: placeholder)
        }
    }

    @ViewBuilder private var retryButtons: some View {
        Button {
            Task { await send() }
        } label: {
            Text(L("重试发送", "Retry send")).frame(minHeight: 44)
        }
        .buttonStyle(.bordered)
        Button {
            pending = nil
            pendingIdentity = nil
        } label: {
            Text(L("取消重试", "Discard retry")).frame(minHeight: 44)
        }
    }

    private func messageRow(_ message: SupportMessage) -> some View {
        let isFromUser = message.sender == "user"
        return VStack(alignment: isFromUser ? .trailing : .leading, spacing: 4) {
            Text(sender(message.sender))
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            VStack(alignment: .leading, spacing: 8) {
                if let text = message.text, !text.isEmpty {
                    Text(text)
                        .fixedSize(horizontal: false, vertical: true)
                        .textSelection(.enabled)
                }
                if let image = message.image {
                    if let url = image.url, url.scheme == "https" {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image): image.resizable().scaledToFit()
                            case .failure: Text(L("图片不可用", "Image unavailable"))
                            default: ProgressView()
                            }
                        }
                        .frame(maxHeight: 240)
                        .accessibilityLabel(L("客服消息图片", "Support message image"))
                    } else {
                        Text(L("这张图片已不可查看", "This photo is no longer available"))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(isFromUser ? Color.accentColor.opacity(0.14) : Color(uiColor: .secondarySystemBackground),
                        in: RoundedRectangle(cornerRadius: 14))
        }
        .padding(isFromUser ? .leading : .trailing, 28)
        .frame(maxWidth: .infinity, alignment: isFromUser ? .trailing : .leading)
    }

    private func sender(_ name: String) -> String {
        switch name {
        case "user": L("你", "You")
        case "admin": L("客服", "Support")
        case "ai": "GeckConnent_Bot"
        default: L("系统", "System")
        }
    }

    private func reload(earlier: Bool = false) async {
        guard !loading, let identity = model.supportIdentity else { return }
        loading = true
        defer { loading = false }
        do {
            var query = "/messages?limit=50"
            if earlier, let first = messages.first { query += "&before=\(first.seq)" }
            if !earlier, let last = messages.last { query += "&after=\(last.seq)" }
            let data = try await model.support(query, identity: identity)
            try Task.checkCancellation()
            guard identity == model.supportIdentity else { return }
            guard let payload = data["messages"] else { throw APIError(code: "response") }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let page = try decoder.decode([SupportMessage].self, from: JSONSerialization.data(withJSONObject: payload))
            if earlier || messages.isEmpty { more = page.count == 50 }
            var merged = Dictionary(messages.map { ($0.seq, $0) }, uniquingKeysWith: { _, new in new })
            for item in page { merged[item.seq] = item }
            messages = merged.values.sorted { $0.seq < $1.seq }
            conversation = data["status"] as? String ?? conversation
            if !sending && pending == nil { error = nil }
            if let last = messages.last, !earlier {
                if (try? await model.support("/read", method: "POST", body: ["seq": last.seq], identity: identity)) != nil,
                   identity == model.supportIdentity { model.supportUnread = 0 }
            }
            if case .visitor = identity, let info = try? await model.support("/conversation", identity: identity),
               identity == model.supportIdentity {
                contact = info["contact_email"] as? String ?? ""
            }
        } catch {
            guard !Task.isCancelled else { return }
            if !signedIn, model.visitorToken == nil {
                visitor = false
                self.error = L("访客会话已失效，请重新验证。", "This guest session expired. Verify again to continue.")
            } else if !sending && pending == nil {
                self.error = error.localizedDescription
            }
        }
    }

    private func send(diagnostics: Bool = false) async {
        guard !sending, let identity = model.supportIdentity else { return }
        guard pending == nil || pendingIdentity == identity else { return }
        sending = true
        error = nil
        defer { sending = false }
        do {
            var body = pending ?? [
                "client_msg_id": UUID().uuidString.replacingOccurrences(of: "-", with: "").lowercased(),
                "source": "ios", "lang": isChinese ? "zh" : "en"
            ]
            if pending == nil {
                body["app_version"] = AppModel.supportVersion
                if diagnostics {
                    body["text"] = L("诊断信息", "Diagnostics") + " · iOS " + AppModel.appVersion
                    body["diagnostics"] = await model.diagnostics()
                } else {
                    let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard text.unicodeScalars.count <= 1000 else { throw APIError(code: "message_too_long") }
                    if !text.isEmpty { body["text"] = text }
                    if let imageData {
                        let fields: [String: Any]
                        if let imageFields { fields = imageFields }
                        else { fields = try await model.uploadImage(imageData, identity: identity); imageFields = fields }
                        body.merge(fields) { _, new in new }
                    }
                }
            }
            guard identity == model.supportIdentity else { return }
            pendingIdentity = identity
            pending = body
            let receipt = try await model.support("/messages", method: "POST", body: body, identity: identity)
            guard identity == model.supportIdentity else { return }
            guard let message = receipt["message"] as? [String: Any],
                  let sequence = message["seq"] as? Int, sequence > 0 else {
                throw APIError(code: "response")
            }
            if body["diagnostics"] == nil {
                draft = ""
                photo = nil
                imageData = nil
                imageFields = nil
            }
            pending = nil
            pendingIdentity = nil
            await reload()
        } catch { if identity == model.supportIdentity { self.error = error.localizedDescription } }
    }
}
