enum AuthMode: String, CaseIterable {
    case login, register, reset

    func title(using L: (String, String) -> String) -> String {
        switch self {
        case .login: L("登录", "Sign in")
        case .register: L("注册", "Create account")
        case .reset: L("重置密码", "Reset password")
        }
    }
}
