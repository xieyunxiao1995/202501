import SwiftUI

struct PreferencesView: View {
    @AppLocalized private var L
    @ObservedObject var model: AppModel
    @AppStorage("theme") private var theme = "system"
    @AppStorage("language") private var language = "system"
    @AppStorage("smartRouting") private var smartRouting = false
    @State private var rulesVersion = RoutingRules.version
    @State private var updating = false
    @State private var issue: String?
    @State private var report = ""

    var body: some View {
        List {
            Section(L("外观", "Appearance")) {
                Picker(L("主题", "Theme"), selection: $theme) {
                    Text(L("跟随系统", "System")).tag("system")
                    Text(L("浅色", "Light")).tag("light")
                    Text(L("深色", "Dark")).tag("dark")
                }
                Picker(L("语言", "Language"), selection: $language) {
                    Text(L("跟随手机", "Device language")).tag("system")
                    Text("简体中文").tag("zh")
                    Text("English").tag("en")
                }
            }
            Section {
                Picker(L("路由模式", "Routing mode"), selection: $smartRouting) {
                    Text(L("全局", "Global")).tag(false)
                    Text(L("智能", "Smart")).tag(true)
                }
                NavigationLink(L("自定义域名规则", "Custom domain rules")) { DomainRulesView() }
                LabeledValue(L("规则版本", "Rules version"), value: String(rulesVersion))
                Button(updating ? L("正在下载规则…", "Downloading rules…") : L("更新路由规则", "Update routing rules")) {
                    Task { await update() }
                }.disabled(updating)
            } header: {
                Text(L("流量路由", "Traffic routing"))
            } footer: {
                Text(L("智能模式将符合规则的流量直连。模式和域名修改在下次连接时生效。", "Smart routing sends matching traffic directly. Mode and domain changes apply on your next connection."))
            }
            Section(L("诊断", "Diagnostics")) {
                Button(L("生成连接诊断", "Generate diagnostics")) { Task { report = await model.diagnosticsText() } }
                if !report.isEmpty {
                    ShareButton(text: report) { Label(L("分享诊断", "Share diagnostics"), systemImage: "square.and.arrow.up") }
                    Text(report).font(.caption.monospaced()).textSelection(.enabled)
                }
            }
            Section(L("关于", "About")) {
                LabeledValue(L("版本", "Version"), value: AppModel.appVersion)
                LabeledValue(L("VPN 内核", "VPN core"), value: AppModel.coreVersion)
                Link(L("帮助中心", "Help center"), destination: URL(string: "https://GeckConnent.com/docs/")!)
                Link(L("隐私政策", "Privacy policy"), destination: URL(string: "https://GeckConnent.com/privacy-policy.html")!)
                Link(L("官方网站", "Website"), destination: model.serviceInfo.website)
                if let url = model.serviceInfo.updateURL { Link(L("查看可用版本", "View the latest version"), destination: url) }
                if !model.serviceInfo.email.isEmpty,
                   let url = URL(string: "mailto:" + model.serviceInfo.email) {
                    Link(L("邮件联系", "Email support"), destination: url)
                }
            }
            if let issue { StatusBanner(tone: .failure, message: issue) }
        }
        .navigationTitle(L("设置", "Settings"))
    }

    private func update() async {
        guard !updating else { return }
        updating = true
        issue = nil
        defer { updating = false }
        do {
            rulesVersion = try await RoutingRules.update()
            await model.tunnel.syncRules()
        } catch { issue = error.localizedDescription }
    }
}
