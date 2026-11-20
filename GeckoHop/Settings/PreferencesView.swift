import SwiftUI

struct PreferencesView: View {
    @AppLocalized private var L
    @ObservedObject var model: AppModel
    @AppStorage("theme") private var theme = "system"
    @AppStorage("language") private var language = "system"
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
            Section(L("诊断", "Diagnostics")) {
                Button(L("生成连接诊断", "Generate diagnostics")) { Task { report = await model.diagnosticsText() } }
                if !report.isEmpty {
                    ShareButton(text: report) { Label(L("分享诊断", "Share diagnostics"), systemImage: "square.and.arrow.up") }
                    Text(report).font(.caption.monospaced()).textSelection(.enabled)
                }
            }
            Section(L("关于", "About")) {
                LabeledValue(L("开发者", "Developer"), value: ServiceInfo.developerName)
                LabeledValue(L("版本", "Version"), value: AppModel.appVersion)
                LabeledValue(L("VPN 内核", "VPN core"), value: AppModel.coreVersion)
                NavigationLink(L("反馈与客服", "Feedback and support")) {
                    SupportView(model: model, diagnosticsOnOpen: false)
                }
                PrivacyNoticeButton(title: L("隐私说明", "Privacy notice"))
                if let url = model.serviceInfo.updateURL { Link(L("查看可用版本", "View the latest version"), destination: url) }
                Link(destination: ServiceInfo.contactURL) {
                    LabeledValue(L("开发者联系邮箱", "Developer email"), value: ServiceInfo.contactEmail)
                }
            }
        }
        .navigationTitle(L("设置", "Settings"))
    }
}
