import SwiftUI

struct SupportContactView: View {
    @AppLocalized private var L
    @ObservedObject var model: AppModel
    @Binding var contact: String
    @State private var email = ""
    @State private var code = ""
    @State private var captcha = false
    @State private var busy = false
    @State private var issue: String?
    @State private var deadlines: [String: Date] = [:]

    private var address: String { email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }

    var body: some View {
        Form {
            if !contact.isEmpty {
                LabeledValue(L("当前邮箱", "Current email"), value: contact)
                Button(L("解绑邮箱", "Unlink email"), role: .destructive) { Task { await save(unlink: true) } }.disabled(busy)
            }
            TextField(L("邮箱", "Email address"), text: $email)
                .keyboardType(.emailAddress).textContentType(.emailAddress)
                .textInputAutocapitalization(.never).autocorrectionDisabled()
            TextField(L("六位验证码", "Six-digit code"), text: $code)
                .keyboardType(.numberPad).textContentType(.oneTimeCode)
            TimelineView(.periodic(from: .now, by: 1)) { time in
                let deadline = deadlines[address] ?? .distantPast
                let seconds = max(0, Int(ceil(deadline.timeIntervalSince(time.date))))
                Button(seconds == 0 ? L("发送验证码", "Send code") : "\(seconds)s") { captcha = true }
                    .disabled(!address.contains("@") || seconds > 0 || busy)
            }
            Button(L("绑定邮箱", "Link email")) { Task { await save() } }
                .disabled(!address.contains("@") || code.count != 6 || busy)
            if let issue { Text(issue).foregroundStyle(.red) }
        }
        .onChangeCompat(of: address) { _ in code = "" }
        .navigationTitle(L("联系邮箱", "Contact email"))
        .sheet(isPresented: $captcha) {
            CaptchaView(api: model.api, email: address, purpose: "support") { ticket in
                guard let identity = model.supportIdentity, case .visitor = identity else { throw CancellationError() }
                let address = address
                do {
                    let data = try await model.support("/contact/code", method: "POST",
                        body: ["email": address, "captcha_token": ticket], identity: identity)
                    guard data["sent"] as? Bool == true else { throw APIError(code: "response") }
                    deadlines[address] = .now.addingTimeInterval(APIClient.emailRetryInterval(data["retry_after"] as? Int))
                } catch let error as APIError {
                    if let wait = error.retryAfter, wait > 0 {
                        deadlines[address] = .now.addingTimeInterval(APIClient.emailRetryInterval(wait))
                    }
                    throw error
                }
            }
        }
    }

    private func save(unlink: Bool = false) async {
        guard !busy, let identity = model.supportIdentity, case .visitor = identity else { return }
        busy = true
        issue = nil
        defer { busy = false }
        do {
            let data = try await model.support("/contact", method: "PUT",
                body: unlink ? ["email": ""] : ["email": address, "code": code], identity: identity)
            contact = data["contact_email"] as? String ?? ""
            code = ""
            email = ""
        } catch { issue = error.localizedDescription }
    }
}
