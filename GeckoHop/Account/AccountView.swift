import SwiftUI

struct AccountView: View {
    @AppLocalized private var L
    @ObservedObject var model: AppModel
    @State private var confirmDelete = false

    var body: some View {
        List {
            if let session = model.session {
                Section(L("账号信息", "Account details")) {
                    LabeledValue(L("邮箱", "Email"), value: session.user.email)
                    LabeledValue(L("权益", "Plan"), value: plan(session.activePlanType))
                    if let remaining = session.user.trafficRemainingBytes {
                        LabeledValue(L("剩余流量", "Traffic remaining"), value: bytes(remaining))
                    }
                    if let expires = session.user.expiresAt, expires > 0 {
                        LabeledValue(L("到期时间", "Expires"), value: Date(timeIntervalSince1970: Double(expires)).formatted(date: .abbreviated, time: .shortened))
                    }
                    if let devices = session.user.maxSessions {
                        LabeledValue(L("同时在线设备", "Concurrent devices"), value: devices.formatted())
                    }
                    speed(L("上传上限", "Upload limit"), session.user.uploadLimitBytesPerSecond)
                    speed(L("下载上限", "Download limit"), session.user.downloadLimitBytesPerSecond)
                }
                Section {
                    NavigationLink(L("邀请与奖励", "Invitations and rewards")) { InviteView(model: model) }
                    Button(L("刷新账号信息", "Refresh account")) { Task { await model.refreshSession() } }
                    Button(L("退出登录", "Sign out")) { Task { await model.signOut() } }
                        .disabled(model.changingAccount)
                }
                Section {
                    Button(role: .destructive) {
                        confirmDelete = true
                    } label: {
                        Text(L("注销账号", "Delete account"))
                    }
                    .disabled(model.changingAccount)
                }
                if let issue = model.issue {
                    StatusBanner(tone: .failure, message: issue)
                }
            }
        }
        .navigationTitle(L("账号", "Account"))
        .alert(L("提交注销申请？", "Request account deletion?"), isPresented: $confirmDelete) {
            Button(L("确认注销", "Confirm deletion"), role: .destructive) {
                Task { await model.requestAccountDeletion() }
            }
            Button(L("取消", "Cancel"), role: .cancel) {}
        } message: {
            Text(L("注销完成后，账号和相关权益将无法恢复。", "Once deletion is complete, your account and its benefits cannot be recovered."))
        }
    }

    @ViewBuilder private func speed(_ title: String, _ amount: Int64?) -> some View {
        if let amount {
            LabeledValue(title, value: amount > 0 ? bytes(amount) + "/s" : L("不限速", "Unlimited"))
        }
    }

    private func plan(_ type: String?) -> String {
        switch type {
        case "traffic": L("流量包", "Data allowance")
        case "unlimited": L("无限流量", "Unlimited")
        case "free", nil: L("基础账号", "Basic account")
        default: type ?? ""
        }
    }
}
