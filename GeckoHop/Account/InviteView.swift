import SwiftUI

struct InviteView: View {
    @AppLocalized private var L
    @ObservedObject var model: AppModel
    @State private var info: [String: Any]?
    @State private var error: String?

    var body: some View {
        List {
            if let info {
                if info["enabled"] as? Bool == true {
                    Section {
                        if let code = info["code"] as? String {
                            LabeledValue(L("邀请码", "Invitation code"), value: code).textSelection(.enabled)
                        }
                        if let link = info["link"] as? String, let url = URL(string: link), url.scheme == "https" {
                            Text(link).font(.footnote).textSelection(.enabled)
                            ShareButton(url: url) { Label(L("分享邀请链接", "Share invitation link"), systemImage: "square.and.arrow.up") }
                        }
                    }
                    Section(L("奖励概览", "Reward summary")) {
                        if let inviter = info["reward_bytes"] as? Int64, let invitee = info["invitee_reward_bytes"] as? Int64 {
                            LabeledValue(L("符合条件时给邀请人", "Per qualifying referral"), value: bytes(inviter))
                            LabeledValue(L("符合条件时给受邀人", "For a qualifying invitee"), value: bytes(invitee))
                        }
                        LabeledValue(L("已邀请", "Invited"), value: "\(info["invited_count"] as? Int ?? 0)")
                        LabeledValue(L("已获得奖励的邀请", "Rewarded referrals"), value: (info["rewarded_count"] as? Int ?? 0).formatted())
                        LabeledValue(L("累计流量奖励", "Total data earned"), value: bytes(info["rewarded_bytes"] as? Int64 ?? 0))
                        if let own = info["own_reward"] as? [String: Any] {
                            LabeledValue(L("我的受邀奖励", "My invitation reward"), value: state(own))
                        }
                    }
                    Section(L("近期记录", "Recent rewards")) {
                        let records = info["records"] as? [[String: Any]] ?? []
                        if records.isEmpty {
                            Text(L("有奖励记录后会显示在这里。", "Reward history appears here.")).foregroundStyle(.secondary)
                        }
                        ForEach(Array(records.enumerated()), id: \.offset) { _, record in
                            LabeledValue {
                                Text(state(record))
                            } label: {
                                Text(record["email"] as? String ?? "")
                                if let seconds = record["created_at"] as? Double, seconds > 0 {
                                    Text(Date(timeIntervalSince1970: seconds), format: .dateTime.year().month().day())
                                }
                            }
                        }
                    }
                } else { Text(L("邀请功能暂未开放。", "Invitations are currently unavailable.")) }
            } else if let error {
                Text(error).foregroundStyle(.red)
                Button(L("重新查询", "Try loading again")) { Task { await load() } }
            } else { ProgressView() }
        }
        .navigationTitle(L("邀请", "Invitations"))
        .task { await load() }
        .refreshable { await load() }
    }

    private func state(_ record: [String: Any]) -> String {
        if let revoked = record["revoked_bytes"] as? Int64, revoked > 0 {
            return L("已收回 ", "Reversed ") + bytes(revoked)
        }
        return switch record["status"] as? String {
        case "granted": bytes(record["reward_bytes"] as? Int64 ?? 0)
        case "pending": L("等待入账", "Awaiting credit")
        case "waiting": L("等待达成条件", "Awaiting eligibility")
        case "skipped": L("不符合条件", "Ineligible")
        default: L("未知", "Unknown")
        }
    }

    private func load() async {
        do { info = try await model.authorized("/user/invite"); error = nil }
        catch { if !Task.isCancelled { self.error = error.localizedDescription } }
    }
}
