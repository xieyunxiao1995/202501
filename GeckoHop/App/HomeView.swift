import SwiftUI

struct HomeView: View {
    @AppLocalized private var L
    @ObservedObject var model: AppModel
    @Environment(\.scenePhase) private var phase
    @AppStorage("privacyAccepted") private var privacyAccepted = false
    @Environment(\.locale) private var locale
    @State private var path: [Destination] = []
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.dynamicTypeSize) private var typeSize
    @State private var switchTarget: Node?
    @State private var supportDiagnostics = false
    @State private var diagnosticsReport = ""

    private enum Destination: Hashable { case account, preferences, support }

    // body 拆成几段：整条修饰链写在一起时，Xcode 26 的编译器推断不出类型。
    var body: some View {
        lifecycle(stack)
    }

    // NavigationStack(path:) 要 iOS 16；旧系统用 NavigationView 加隐藏的 NavigationLink，同样由 path 控制。
    @ViewBuilder private var stack: some View {
        if #available(iOS 16, *) {
            NavigationStack(path: $path) {
                navigation.navigationDestination(for: Destination.self) { destinationView($0) }
            }
        } else {
            NavigationView {
                navigation.background(legacyLinks)
            }
            .navigationViewStyle(.stack)
        }
    }

    private var navigation: some View {
        dialogs.navigationBarHiddenCompat()
    }

    @ViewBuilder private func destinationView(_ destination: Destination) -> some View {
        switch destination {
        case .account: AccountView(model: model)
        case .preferences: PreferencesView(model: model)
        case .support: SupportView(model: model, diagnosticsOnOpen: supportDiagnostics)
        }
    }

    private var legacyLinks: some View {
        ForEach([Destination.account, .preferences, .support], id: \.self) { destination in
            NavigationLink(isActive: Binding(
                get: { path.last == destination },
                set: { active in
                    if active { path = [destination] } else if path.last == destination { path = [] }
                }
            )) {
                destinationView(destination).navigationBarHidden(false)
            } label: { EmptyView() }
        }
        .hidden()
    }

    private var dialogs: some View {
        content
            .alert(L("账号已注销", "Account deleted"), isPresented: deletionReceipt) {
                Button(L("知道了", "OK"), role: .cancel) {}
            } message: {
                Text(L("服务端已确认删除你的账号。", "The service confirmed that your account was deleted."))
            }
            .confirmationDialog(L("切换线路？", "Switch route?"), isPresented: switchPrompt, presenting: switchTarget) { node in
                Button(L("切换并连接", "Switch and connect")) { Task { await model.switchTo(node) } }
            } message: { node in
                Text(switchMessage(node))
            }
    }

    private var deletionReceipt: Binding<Bool> {
        Binding(get: { model.showDeletionReceipt }, set: { if !$0 { model.dismissDeletionReceipt() } })
    }

    // confirmationDialog(item:) 只在新 SDK 里有，这里用 iOS 15 起就有的 isPresented + presenting。
    private var switchPrompt: Binding<Bool> {
        Binding(get: { switchTarget != nil }, set: { if !$0 { switchTarget = nil } })
    }

    private func switchMessage(_ node: Node) -> String {
        L("将断开当前线路并连接", "Disconnect the current route and connect to") + " " + node.name
    }

    private var content: some View {
        Group {
            if privacyAccepted, !model.serviceInfo.requiresUpdate, !model.restoring, model.session == nil {
                AuthView(model: model)
                    .transition(.opacity)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        header
                        if model.serviceInfo.requiresUpdate { upgrade }
                        else if !privacyAccepted { disclosure }
                        else if model.restoring {
                            ProgressView(L("正在恢复账号…", "Restoring your account…"))
                                .frame(maxWidth: .infinity, minHeight: 180)
                        } else {
                            announcement
                            dashboard
                        }
                    }
                    .padding(.horizontal, 22)
                    .padding(.vertical, 20)
                    .frame(maxWidth: model.session == nil ? 560 : 980)
                    .frame(maxWidth: .infinity)
                }
                .refreshable { await refresh(force: true) }
                .transition(.opacity)
            }
        }
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.22), value: model.session != nil)
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.22), value: model.restoring)
    }

    private func lifecycle(_ view: some View) -> some View {
        polling(view)
            .onChangeCompat(of: model.session?.user.uuid) { _ in
                path = []
            }
            .onChangeCompat(of: model.serviceInfo.requiresUpdate) { requiresUpdate in
                if requiresUpdate { path = [] }
            }
            .onChangeCompat(of: locale.identifier) { _ in
                Task { if privacyAccepted { await model.serviceInfo.refreshNotices(api: model.api, force: true) } }
            }
    }

    private func polling(_ view: some View) -> some View {
        view
            .task(id: phase == .active ? (privacyAccepted ? 2 : 1) : 0) {
                guard phase == .active else { return }
                guard privacyAccepted else { return }
                async let version: Void = model.serviceInfo.refreshVersion(api: model.api)
                await model.bootstrap()
                _ = await version
                if !Task.isCancelled, model.session != nil { await refresh() }
            }
            .task(id: phase == .active && privacyAccepted) {
                guard phase == .active, privacyAccepted else { return }
                var unreadPoll = 0
                while !Task.isCancelled {
                    await model.tunnel.sample()
                    if unreadPoll.isMultiple(of: 15) { Task { await model.refreshSupportUnread() } }
                    unreadPoll += 1
                    do { try await Task.sleep(seconds: 1) } catch { break }
                }
            }
            .task(id: model.session?.user.uuid) {
                if privacyAccepted, model.session != nil { await refresh() }
            }
    }

    private var header: some View {
        HorizontalFit {
            HStack(alignment: .center) {
                brand
                Spacer(minLength: 12)
                if privacyAccepted, model.session != nil, !model.serviceInfo.requiresUpdate { tools }
                else { LanguageMenu().buttonStyle(HeaderButtonStyle()) }
            }
        } fallback: {
            VStack(alignment: .leading, spacing: 8) {
                brand
                if privacyAccepted, model.session != nil, !model.serviceInfo.requiresUpdate { tools }
                else { LanguageMenu().buttonStyle(HeaderButtonStyle()) }
            }
        }
    }

    private var brand: some View {
        HStack(spacing: 9) {
            Image("GeckoMark")
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
                .foregroundStyle(Palette.active)
                .frame(width: 36, height: 36)
                .background(Palette.panel, in: RoundedRectangle(cornerRadius: 10))
                .accessibilityHidden(true)
            Text("GeckConnent").font(.title2.weight(.bold)).accessibilityAddTraits(.isHeader)
        }
        .fixedSize(horizontal: true, vertical: false)
    }

    private var tools: some View {
        HStack(spacing: 3) {
            Button {
                supportDiagnostics = false
                path.append(.support)
            } label: {
                Label(L("客服", "Support"), systemImage: model.supportUnread > 0 ? "lifepreserver.fill" : "lifepreserver")
                    .accessibilityValue(model.supportUnread > 0 ? "\(model.supportUnread)" : "")
            }
            Button { path.append(.preferences) } label: { Label(L("设置", "Settings"), systemImage: settingsSymbol) }
            Button { path.append(.account) } label: { Label(L("账号", "Account"), systemImage: "person.text.rectangle") }
        }
        .labelStyle(.iconOnly)
        .font(.title3)
        .buttonStyle(HeaderButtonStyle())
        .foregroundStyle(.primary)
    }

    /// dial.low 是 iOS 16 的图标，旧系统用样子接近的 dial.min。
    private var settingsSymbol: String {
        if #available(iOS 16, *) { return "dial.low" }
        return "dial.min"
    }

    private var disclosure: some View {
        VStack(alignment: .leading, spacing: 18) {
            Image(systemName: "hand.raised").font(.largeTitle).accessibilityHidden(true)
            Text(L("使用前了解数据用途", "How your data is used"))
                .font(.largeTitle.bold()).accessibilityAddTraits(.isHeader)
            VStack(alignment: .leading, spacing: 12) {
                disclosureRow(L("账号", "Account"), L(
                    "邮箱和账号标识用于登录、验证及账号管理。",
                    "Your email and account identifier are used for sign-in, verification, and account management."
                ))
                disclosureRow(L("VPN 连接", "VPN connection"), L(
                    "所选节点、连接会话和流量使用量用于提供连接和核算额度。账号令牌与临时设备公钥用于授权。IP 地址可能用于安全和防滥用。",
                    "Selected routes, connection sessions, and data usage support connectivity and your allowance. Your account token and a temporary public key authorize the VPN. IP addresses may be used for security and abuse prevention."
                ))
                disclosureRow(L("连通性与客服", "Connectivity and support"), L(
                    "连接后，VPN 通过所选节点转发流量，并向 Google 的连通性检测端点发送不含账号信息的请求。客服接收你主动发送的消息、图片和诊断。",
                    "When connected, the VPN routes traffic through your selected server and sends a connectivity check to a Google endpoint without account details. Support receives the messages, photos, and diagnostics you choose to send."
                ))
            }
            PrivacyNoticeButton(title: L("查看隐私说明", "Read the privacy notice"))
                .foregroundStyle(Palette.signal)
            Button(L("继续", "Continue")) { privacyAccepted = true }
                .buttonStyle(.borderedProminent)
                .tint(Palette.signal)
                .foregroundStyle(Palette.ink)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .foregroundStyle(.white)
        .background(Palette.panel, in: RoundedRectangle(cornerRadius: 18))
    }

    private func disclosureRow(_ title: String, _ message: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.subheadline.weight(.semibold))
            Text(message).font(.subheadline).foregroundStyle(Palette.muted)
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    @ViewBuilder private var announcement: some View {
        if let notice = model.serviceInfo.notice, let title = notice["title"] as? String {
            StatusBanner(tone: notice["level"] as? String == "warning" ? .warning : .information,
                         message: notice["body"] as? String ?? "", title: title) {
                Task { await model.serviceInfo.dismiss(api: model.api) }
            }
        }
    }

    private var upgrade: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(L("更新后继续使用", "Update to continue")).font(.largeTitle.bold())
            Text(model.serviceInfo.upgrade?["notes"] as? String ?? "")
            if let url = model.serviceInfo.updateURL {
                Link(L("打开更新页面", "Open update page"), destination: url).buttonStyle(.borderedProminent)
            }
        }
    }

    private var dashboard: some View {
        let wide = horizontalSizeClass == .regular && !typeSize.isAccessibilitySize
        return AdaptiveStack(wide: wide, wideSpacing: 24, narrowSpacing: 22) {
            VStack(alignment: .leading, spacing: 12) {
                ConnectionPanel(model: model)
                if let issue = model.issue {
                    StatusBanner(tone: .failure, message: issue) { model.issue = nil }
                }
                diagnosticActions
            }
            .animation(reduceMotion ? .easeOut(duration: 0.12) : .easeOut(duration: 0.22), value: model.issue)
            .frame(maxWidth: wide ? 420 : .infinity)
            routes
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var routes: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack {
                Text(L("线路", "Routes")).font(.title2.bold()).accessibilityAddTraits(.isHeader)
                Spacer()
                if model.loadingNodes { ProgressView().controlSize(.small) }
                Button(L("重新加载", "Reload")) {
                    Task { await refresh(force: true) }
                }
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 8)
                .frame(minHeight: 44)
                .disabled(model.loadingNodes)
            }
            if let error = model.nodesError {
                StatusBanner(tone: .failure, message: error, title: L("线路加载失败", "Routes could not load"))
            } else if model.nodes.isEmpty, !model.loadingNodes {
                Text(L("暂无可用线路。下拉可刷新。", "No routes available. Pull to refresh."))
                    .font(.subheadline).foregroundStyle(.secondary)
            }
            ForEach(model.nodes) { node in
                Divider()
                Button {
                    if model.tunnel.active || model.preparing {
                        if node.id != model.selected?.id { switchTarget = node }
                    } else { model.select(node) }
                } label: {
                    HStack(spacing: 13) {
                        let selected = model.selected?.id == node.id
                        Text(node.regionCode.uppercased())
                            .font(.caption.monospaced().weight(.semibold))
                            .frame(minWidth: 42, minHeight: 30)
                            .background(.quaternary, in: RoundedRectangle(cornerRadius: 7))
                            .accessibilityHidden(true)
                        Text(node.name).font(.body.weight(.medium))
                        Spacer(minLength: 4)
                        Image(systemName: "diamond.fill")
                            .font(.caption)
                            .foregroundStyle(.tint)
                            .opacity(selected ? 1 : 0)
                            .scaleEffect(reduceMotion || selected ? 1 : 0.75)
                            .accessibilityHidden(true)
                    }
                    .padding(.horizontal, 10)
                    .frame(minHeight: 52)
                    .background(model.selected?.id == node.id ? Palette.signal.opacity(0.20) : .clear,
                                in: RoundedRectangle(cornerRadius: 10))
                    .contentShape(Rectangle())
                    .animation(reduceMotion ? nil : .easeInOut(duration: 0.22), value: model.selected?.id)
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("route." + node.id)
                .accessibilityAddTraits(model.selected?.id == node.id ? .isSelected : [])
                .disabled(model.stopping)
            }
        }
    }

    @ViewBuilder private var diagnosticActions: some View {
        if model.issue != nil || model.tunnel.internetReachable == false ||
            ["checking", "blocked", "reconnecting", "error", "failed"].contains(model.tunnel.status) {
            HorizontalFit {
                HStack(spacing: 18) { diagnosticButtons }
            } fallback: {
                VStack(alignment: .leading, spacing: 8) { diagnosticButtons }
            }
            .font(.subheadline.weight(.medium))
            .sheet(isPresented: Binding(get: { !diagnosticsReport.isEmpty }, set: { if !$0 { diagnosticsReport = "" } })) {
                NavigationStackCompat {
                    ScrollView {
                        Text(diagnosticsReport).font(.footnote.monospaced()).textSelection(.enabled)
                            .frame(maxWidth: .infinity, alignment: .leading).padding()
                    }
                    .navigationTitle(L("连接诊断", "Connection diagnostics"))
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button(L("关闭", "Close")) { diagnosticsReport = "" }
                        }
                        ToolbarItem(placement: .primaryAction) {
                            ShareButton(text: diagnosticsReport) {
                                Label(L("分享", "Share"), systemImage: "square.and.arrow.up")
                            }
                        }
                    }
                }
            }
        }
    }

    private var diagnosticButtons: some View {
        Group {
            Button {
                supportDiagnostics = true
                path.append(.support)
            } label: {
                Label(L("发送诊断给客服", "Send diagnostics to support"), systemImage: "lifepreserver")
            }
            Button {
                Task { diagnosticsReport = await model.diagnosticsText() }
            } label: {
                Label(L("查看诊断", "View diagnostics"), systemImage: "doc.text.magnifyingglass")
            }
        }
    }

    private func refresh(force: Bool = false) async {
        guard privacyAccepted, model.session != nil else { return }
        await model.refreshNodes()
        await model.serviceInfo.refreshNotices(api: model.api, force: force)
        await model.refreshSession()
    }
}
