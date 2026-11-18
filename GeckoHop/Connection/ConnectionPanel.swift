import SwiftUI

struct ConnectionPanel: View {
    @AppLocalized private var L
    @ObservedObject var model: AppModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var tunnel: Tunnel { model.tunnel }
    private var online: Bool { tunnel.status == "connected" }
    private var working: Bool { model.preparing || tunnel.status == "connecting" }
    private var selectedName: String {
        if tunnel.active && !tunnel.nodeName.isEmpty { return tunnel.nodeName }
        return model.selected?.name ?? L("未选线路", "No route")
    }
    private var actionTitle: String {
        if model.restoring { return L("正在读取会话…", "Restoring session…") }
        if model.stopping { return L("正在断开…", "Disconnecting…") }
        if working { return L("取消连接", "Cancel connection") }
        if tunnel.active { return L("断开 VPN", "Disconnect VPN") }
        return L("连接 VPN", "Connect VPN")
    }
    private var stateTitle: String {
        if model.preparing { return L("正在授权", "Authorizing") }
        switch tunnel.status {
        case "connected": return L("已连接", "Connected")
        case "checking", "connecting": return L("正在连接", "Connecting")
        case "reconnecting": return L("正在恢复隧道", "Restoring the tunnel")
        case "blocked": return L("连接受限", "Connection blocked")
        case "disconnecting": return L("正在关闭隧道", "Closing the tunnel")
        case "error", "failed": return L("连接中断", "Connection interrupted")
        default: return L("VPN 未连接", "VPN off")
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 17) {
            HStack(spacing: 10) {
                Image(systemName: online ? "diamond.fill" : "diamond")
                    .font(.title3)
                    .foregroundStyle(online ? Palette.active : Palette.signal)
                    .accessibilityHidden(true)
                Text(stateTitle)
                    .font(.largeTitle.weight(.bold))
                    .accessibilityAddTraits(.isHeader)
                    .opacityTransitionCompat()
            }
            if online {
                HStack {
                    Text(tunnel.ruleRouting ? L("智能路由", "Smart routing") : L("全局路由", "Global routing"))
                    if let startedAt = tunnel.startedAt {
                        Spacer()
                        Text(startedAt, style: .timer).monospacedDigit()
                    }
                }
                .font(.footnote)
                .foregroundStyle(Palette.muted)
            }
            RouteTrace(destination: selectedName, online: online)
                .animation(reduceMotion ? nil : .easeInOut(duration: 0.24), value: selectedName)
                .animation(reduceMotion ? nil : .easeInOut(duration: 0.24), value: online)
            if tunnel.active && !working {
                HorizontalFit {
                    HStack(spacing: 22) { metrics }
                } fallback: {
                    VStack(alignment: .leading, spacing: 6) { metrics }
                }
            }
            if tunnel.internetReachable == false {
                Text(L("隧道已连接，暂时无法访问互联网。", "The tunnel is connected, but the internet is unreachable."))
                    .font(.footnote).foregroundStyle(Palette.muted)
            }
            if tunnel.failure != nil {
                Text(tunnel.failure?.contains("com.GeckConnent.app.core:106") == true
                     ? L("同时在线设备已达上限。", "Too many devices are connected.")
                     : L("隧道已停止，请重试或查看连接诊断。", "The tunnel stopped. Try again or open diagnostics."))
                    .font(.footnote).foregroundStyle(Palette.muted)
            }
            Button(action: act) {
                Label(actionTitle, systemImage: working || tunnel.active ? "stop.fill" : "arrow.right")
                    .font(.headline)
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .foregroundStyle(Palette.ink)
                    .background(Palette.signal, in: RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
            .disabled(model.stopping || model.restoring || model.changingAccount ||
                      (!tunnel.active && !working && model.session != nil && model.selected == nil))
            if ["blocked", "failed", "reconnecting"].contains(tunnel.status) {
                Button(L("立即重试", "Retry now")) {
                    Task {
                        do { try await tunnel.retry() }
                        catch { model.issue = error.localizedDescription }
                    }
                }.foregroundStyle(Palette.signal)
            }
        }
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.22), value: stateTitle)
        .foregroundStyle(.white)
        .padding(22)
        .background(Palette.panel, in: RoundedRectangle(cornerRadius: 18))
    }

    private var metrics: some View {
        Group {
            Label(bytes(tunnel.download), systemImage: "tray.and.arrow.down")
                .accessibilityLabel(L("下载", "Download") + " " + bytes(tunnel.download))
            Label(bytes(tunnel.upload), systemImage: "tray.and.arrow.up")
                .accessibilityLabel(L("上传", "Upload") + " " + bytes(tunnel.upload))
        }
        .font(.subheadline.monospacedDigit())
        .foregroundStyle(Palette.muted)
    }

    private func act() {
        if working || tunnel.active { Task { await model.stop() } }
        else { model.connect() }
    }
}

func bytes(_ value: Int64) -> String {
    ByteCountFormatter.string(fromByteCount: value, countStyle: .file)
}
