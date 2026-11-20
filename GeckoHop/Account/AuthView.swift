import SwiftUI

struct AuthView: View {
    @AppLocalized private var L
    @ObservedObject var model: AppModel
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.dynamicTypeSize) private var typeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Namespace private var authModeIndicator
    @State private var mode = AuthMode.login
    @State private var email = ""
    @State private var password = ""
    @State private var confirmation = ""
    @State private var showsPassword = false
    @State private var code = ""
    @State private var invite = ""
    @State private var error: String?
    @State private var message: String?
    @State private var submitting = false
    @State private var showCaptcha = false
    @State private var cooldowns: [String: Date] = [:]

    private var controlTint: Color { colorScheme == .dark ? Palette.signal : Palette.panel }
    private var address: String { email.trimmingCharacters(in: .whitespacesAndNewlines) }
    private var validEmail: Bool { address.range(of: #"^[!-~]+@[^\s@]+\.[^\s@]+$"#, options: .regularExpression) != nil && address.utf8.allSatisfy { $0 < 128 } }
    private var validPassword: Bool { (8...32).contains(password.utf8.count) && password.utf8.allSatisfy { (33...126).contains($0) } }

    var body: some View {
        let wide = horizontalSizeClass == .regular && !typeSize.isAccessibilitySize
        ScrollView {
            AdaptiveStack(wide: wide, wideSpacing: 34, narrowSpacing: 26) {
                welcome
                    .frame(maxWidth: wide ? 300 : .infinity, alignment: .leading)
                form
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 24)
            .frame(maxWidth: wide ? 860 : 490)
            .frame(maxWidth: .infinity)
        }
        .onChangeCompat(of: address.lowercased()) { _ in
            code = ""
            message = nil
        }
        .tint(controlTint)
        .scrollDismissesKeyboardCompat()
        .sheet(isPresented: $showCaptcha) {
            CaptchaView(api: model.api, email: address, purpose: mode.rawValue) { ticket in
                let address = address.lowercased()
                do {
                    let wait = try await model.api.sendAccountCode(email: address, ticket: ticket, mode: mode)
                    cooldowns[address] = .now.addingTimeInterval(wait)
                    message = L("验证码已发送，请检查邮箱。", "Check your inbox for the verification code.")
                } catch let failure as APIError {
                    if let wait = failure.retryAfter, wait > 0 { cooldowns[address] = .now.addingTimeInterval(APIClient.emailRetryInterval(wait)) }
                    throw failure
                }
            }
        }
    }

    private var welcome: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 12) {
                Image("GeckoMark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .foregroundStyle(Palette.active)
                    .accessibilityHidden(true)
                Spacer(minLength: 4)
                LanguageMenu().tint(Palette.signal)
            }
            Text("GeckConnent").font(.largeTitle.bold()).accessibilityAddTraits(.isHeader)
            Text(L("登录或创建账号后，即可选择 VPN 线路。", "Sign in or create an account to choose a VPN route."))
                .font(.subheadline)
                .foregroundStyle(Palette.muted)
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(.white)
        .background(Palette.panel, in: RoundedRectangle(cornerRadius: 18))
    }

    private var form: some View {
        VStack(alignment: .leading, spacing: 16) {
            if mode == .reset {
                Text(mode.title(using: L)).font(.title2.bold()).accessibilityAddTraits(.isHeader)
            } else {
                HStack(spacing: 4) {
                    modeButton(.login)
                    modeButton(.register)
                }
                .padding(4)
                .background(.quaternary.opacity(0.45), in: RoundedRectangle(cornerRadius: 13))
            }

            if let message { StatusBanner(tone: .success, message: message) }
            fields
            if let error { StatusBanner(tone: .failure, message: error) }
            Button {
                Task { await submit() }
            } label: {
                HStack {
                    if submitting { ProgressView().controlSize(.small).tint(colorScheme == .dark ? Palette.ink : .white) }
                    Text(submitting ? L("正在提交…", "Submitting…") : mode.title(using: L))
                        .opacityTransitionCompat()
                }
                .frame(maxWidth: .infinity, minHeight: 36)
            }
            .accessibilityIdentifier("auth.submit")
            .buttonStyle(.borderedProminent)
            .tint(controlTint)
            .foregroundStyle(colorScheme == .dark ? Palette.ink : .white)
            .disabled(submitting)
            .animation(reduceMotion ? .easeOut(duration: 0.12) : .easeInOut(duration: 0.25), value: submitting)

            if mode == .login || mode == .reset {
                Button(mode == .login ? L("忘记密码？", "Forgot password?") : L("返回登录", "Back to sign in")) {
                    switchMode(mode == .login ? .reset : .login)
                }
                .frame(minHeight: 44)
                .disabled(submitting)
            }
            Divider()
            PrivacyNoticeButton(title: L("隐私说明", "Privacy notice"))
                .font(.footnote.weight(.medium))
                .frame(minHeight: 44)
        }
        .animation(reduceMotion ? .easeOut(duration: 0.12) : .easeOut(duration: 0.22), value: error)
        .animation(reduceMotion ? .easeOut(duration: 0.12) : .easeOut(duration: 0.22), value: message)
    }

    private var fields: some View {
        VStack(alignment: .leading, spacing: 13) {
            field(L("邮箱", "Email address")) {
                TextField(L("邮箱", "Email address"), text: $email, prompt: Text(""))
                    .accessibilityLabel(L("邮箱", "Email address"))
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
            passwordEntry
            if mode != .login {
                let repeatTitle = L("再输入一次密码", "Repeat password")
                field(repeatTitle) { passwordInput(repeatTitle, value: $confirmation) }
                Text(L("密码须为 8–32 个可打印 ASCII 字符，不含空格。", "Use 8–32 printable ASCII characters without spaces."))
                    .font(.footnote).foregroundStyle(.primary.opacity(0.8))
                field(L("六位邮件验证码", "Six-digit email code")) {
                    TextField(L("六位邮件验证码", "Six-digit email code"), text: $code, prompt: Text(""))
                        .accessibilityLabel(L("六位邮件验证码", "Six-digit email code"))
                        .keyboardType(.numberPad).textContentType(.oneTimeCode)
                }
                TimelineView(.periodic(from: .now, by: 1)) { time in
                    let deadline = cooldowns[address.lowercased()] ?? .distantPast
                    let remaining = max(0, Int(ceil(deadline.timeIntervalSince(time.date))))
                    Button(remaining == 0 ? L("发送验证码", "Send email code") : L("重新发送", "Resend in") + " \(remaining)s") {
                        guard validEmail else { error = L("请输入有效邮箱。", "Enter a valid email address."); return }
                        error = nil
                        showCaptcha = true
                    }
                    .disabled(remaining > 0)
                    .frame(minHeight: 44)
                    .countdownTransitionCompat(reduceMotion: reduceMotion)
                    .animation(reduceMotion ? nil : .easeOut(duration: 0.18), value: remaining)
                }
            }
            if mode == .register {
                field(L("邀请码（可选）", "Invitation code (optional)")) {
                    TextField(L("邀请码（可选）", "Invitation code (optional)"), text: $invite, prompt: Text(""))
                        .accessibilityLabel(L("邀请码（可选）", "Invitation code (optional)"))
                        .textInputAutocapitalization(.characters).autocorrectionDisabled()
                }
            }
        }
        .disabled(submitting)
    }

    private var passwordEntry: some View {
        let title = mode == .reset ? L("新密码", "New password") : L("密码", "Password")
        return field(title) {
            HStack(spacing: 10) {
                passwordInput(title, value: $password)
                Button(showsPassword ? L("隐藏", "Hide") : L("显示", "Show")) {
                    showsPassword.toggle()
                }
                .accessibilityLabel(showsPassword ? L("隐藏密码", "Hide password") : L("显示密码", "Show password"))
                .font(.subheadline.weight(.semibold))
                .frame(minWidth: 44, minHeight: 44)
            }
        }
    }

    @ViewBuilder
    private func passwordInput(_ title: String, value: Binding<String>) -> some View {
        if showsPassword {
            TextField(title, text: value, prompt: Text(""))
                .accessibilityLabel(title)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .textContentType(mode == .login ? .password : .newPassword)
        } else {
            SecureField(title, text: value, prompt: Text(""))
                .accessibilityLabel(title)
                .textContentType(mode == .login ? .password : .newPassword)
        }
    }

    private func field<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.subheadline.weight(.medium)).accessibilityHidden(true)
            content()
                .textFieldStyle(.plain)
                .padding(.horizontal, 12)
                .frame(minHeight: 44)
                .background(.quaternary.opacity(0.55), in: RoundedRectangle(cornerRadius: 9))
        }
    }

    private func modeButton(_ target: AuthMode) -> some View {
        let selected = mode == target
        return Button {
            switchMode(target)
        } label: {
            Text(target.title(using: L))
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 6)
                .frame(maxWidth: .infinity, minHeight: 44)
                .background {
                    if selected {
                        // 分段指示块从登录滑到注册，减少动态效果时直接切换。
                        if reduceMotion {
                            RoundedRectangle(cornerRadius: 9).fill(Color.primary.opacity(0.09))
                        } else {
                            RoundedRectangle(cornerRadius: 9)
                                .fill(Color.primary.opacity(0.09))
                                .matchedGeometryEffect(id: "selection", in: authModeIndicator)
                        }
                    }
                }
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("auth.mode." + target.rawValue)
        .accessibilityAddTraits(selected ? .isSelected : [])
        .disabled(submitting)
    }

    private func switchMode(_ target: AuthMode) {
        guard mode != target else { return }
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.24)) {
            mode = target
            password = ""
            confirmation = ""
            showsPassword = false
            code = ""
            error = nil
            message = nil
        }
    }

    private func submit() async {
        guard !submitting else { return }
        guard validEmail, validPassword else {
            error = L("请检查邮箱和密码。", "Check the email address and password.")
            return
        }
        let emailCode = code.trimmingCharacters(in: .whitespacesAndNewlines)
        if mode != .login, emailCode.utf8.count != 6 || !emailCode.utf8.allSatisfy({ (48...57).contains($0) }) {
            error = L("请输入六位验证码。", "Enter the six-digit verification code.")
            return
        }
        if mode != .login, password != confirmation {
            error = L("两次输入的密码不一致。", "The two password entries differ.")
            return
        }
        let inviteCode = invite.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if mode == .register, !inviteCode.isEmpty,
           inviteCode.range(of: #"^[2-9A-HJ-NP-Z]{8}$"#, options: .regularExpression) == nil {
            error = L("请检查八位邀请码，或留空继续注册。", "Check the eight-character invitation code or leave it blank.")
            return
        }
        submitting = true
        error = nil
        message = nil
        defer { submitting = false }
        do {
            if mode == .reset {
                try await model.api.resetPassword(email: address, code: emailCode, password: password)
                mode = .login
                password = ""
                confirmation = ""
                showsPassword = false
                code = ""
                message = L("密码已重置，请重新登录。", "Password updated. Sign in with the new password.")
                return
            }
            var body = ["email": address, "password": password]
            if mode == .register {
                body["code"] = emailCode
                if !inviteCode.isEmpty { body["invite_code"] = inviteCode }
            }
            try await model.authenticate(path: "/user/" + mode.rawValue, body: body)
        } catch { self.error = error.localizedDescription }
    }
}
