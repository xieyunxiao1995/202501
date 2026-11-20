import SwiftUI

struct PrivacyNoticeButton: View {
    @AppLocalized private var L
    @State private var showingNotice = false

    let title: String

    var body: some View {
        Button(title) { showingNotice = true }
            .sheet(isPresented: $showingNotice) {
                NavigationView {
                    notice
                        .navigationTitle(L("隐私说明", "Privacy notice"))
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button(L("完成", "Done")) { showingNotice = false }
                            }
                        }
                }
                .navigationViewStyle(.stack)
            }
    }

    private var notice: some View {
        List {
            Section(L("开发者", "Developer")) {
                Text(ServiceInfo.developerName)
            }
            Section(L("账号", "Account")) {
                Text(L(
                    "注册和登录时，服务使用你的邮箱和账号标识进行验证及账号管理。登录令牌保存在设备钥匙串中，用于维持登录和授权。",
                    "The service uses your email address and account identifier for verification and account management. Sign-in tokens are stored in the device keychain to maintain your session and authorize access."
                ))
            }
            Section(L("VPN 连接", "VPN connection")) {
                Text(L(
                    "连接时，VPN 通过你所选的节点转发流量。服务使用所选节点、连接会话和流量用量来提供连接及核算额度，并使用账号令牌和临时设备公钥授权。IP 地址可能用于安全和防滥用。",
                    "The VPN routes traffic through the server you select. The service uses the selected server, connection session, and data usage to provide access and calculate your allowance. Your account token and a temporary device public key authorize the connection. IP addresses may be used for security and abuse prevention."
                ))
                Text(L(
                    "连接后，App 会向 Google 的连通性检测端点发送 HTTPS 请求，以判断互联网是否可用。请求不附带账号凭据。",
                    "After connecting, the app makes an HTTPS request to a Google connectivity endpoint to check internet availability. The request does not include account credentials."
                ))
            }
            Section(L("客服与反馈", "Support and feedback")) {
                Text(L(
                    "客服使用你主动提交的留言、照片及连接诊断来处理反馈。连接诊断可能包含系统版本、所选节点、连接状态和近期错误。",
                    "Support uses the messages, photos, and connection diagnostics you choose to send to respond to you. Connection diagnostics can include the OS version, selected server, connection status, and recent errors."
                ))
            }
            Section(L("账户删除与隐私联系", "Account deletion and privacy contact")) {
                Text(L(
                    "登录后，可在「账号 > 注销账号」提交删除请求。服务端确认删除后，App 会显示结果。如需询问数据保存或处理方式，请联系开发者。",
                    "After signing in, you can request deletion under Account > Delete account. The app displays confirmation after the service confirms deletion. Contact the developer with questions about how your data is retained or used."
                ))
                Link(ServiceInfo.contactEmail, destination: ServiceInfo.contactURL)
            }
        }
    }
}
