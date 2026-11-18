import SwiftUI

struct DomainRulesView: View {
    @AppLocalized private var L
    @State private var rules = UserDefaults.standard.array(forKey: "customRoutes") as? [[String: String]] ?? []
    @State private var input = ""
    @State private var direct = true
    @State private var issue: String?

    var body: some View {
        List {
            Section(L("添加域名", "Add domain")) {
                TextField("example.com", text: $input)
                    .textInputAutocapitalization(.never).autocorrectionDisabled().keyboardType(.URL)
                Picker(L("流量方向", "Traffic path"), selection: $direct) {
                    Text(L("直连", "Direct")).tag(true)
                    Text(L("通过 VPN", "Via VPN")).tag(false)
                }
                Button(L("保存规则", "Save rule"), action: save)
                if let issue { Text(issue).foregroundStyle(.red) }
            }
            Section(L("已保存", "Saved rules")) {
                if rules.isEmpty { Text(L("暂无自定义规则。", "No custom rules.")).foregroundStyle(.secondary) }
                ForEach(rules, id: \.self) { item in
                    LabeledValue(item["domain"] ?? "", value: item["out"] == "direct" ? L("直连", "Direct") : L("通过 VPN", "Via VPN"))
                }
                .onDelete { indexes in
                    rules.remove(atOffsets: indexes)
                    persist()
                }
            }
        }
        .navigationTitle(L("自定义规则", "Domain rules"))
    }

    private func save() {
        guard let domain = RoutingRules.domain(input) else {
            issue = L("请输入有效域名。", "Enter a valid domain.")
            return
        }
        guard rules.count < 200 || rules.contains(where: { $0["domain"] == domain }) else {
            issue = L("最多可保存 200 条规则。", "You can save up to 200 rules.")
            return
        }
        rules.removeAll { $0["domain"] == domain }
        rules.insert(["domain": domain, "out": direct ? "direct" : "proxy"], at: 0)
        input = ""
        issue = nil
        persist()
    }

    private func persist() { UserDefaults.standard.set(rules, forKey: "customRoutes") }
}
