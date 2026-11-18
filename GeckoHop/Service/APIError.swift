import Foundation

struct APIError: LocalizedError {
    var status = 0
    let code: String
    var retryAfter: Int?
    var suggestion: String?

    var errorDescription: String? {
        let text: String
        switch code {
        case "invalid_credentials", "invalid_email_or_password": text = L("邮箱或密码有误，请检查。", "Check your email and password.")
        case "invalid_token", "token_revoked", "token_expired": text = L("请再次登录以恢复账号访问。", "Sign in again to regain access to your account.")
        case "paid_entitlement_required": text = L("此账号暂无有效的连接权益。", "This account has no active VPN entitlement.")
        case "node_unavailable", "node_config_unavailable": text = L("线路暂不可用，请换一条线路。", "This route is unavailable. Choose another route.")
        case "invalid_invite_code": text = L("邀请码无效。", "The invitation code is invalid.")
        case "invalid_captcha", "captcha_position": text = L("拼图验证未通过，请重新取题再试。", "The puzzle check did not pass. Load a new puzzle to try again.")
        case "invalid_code", "invalid_verification_code", "code_expired": text = L("邮件验证码无效或已过期。", "The email code is invalid or expired.")
        case "membership_active": text = L("会员权益仍有效，暂时无法注销。", "An active membership prevents account deletion.")
        case "payment_pending": text = L("仍有订单处理中，暂时无法注销。", "A pending payment prevents account deletion.")
        case "device_clock_ahead": text = L("请在系统设置开启自动设置时间。", "Turn on automatic date and time in Settings.")
        case "prepare_timeout": text = L("线路授权准备超时，请重试。", "Route authorization timed out. Try again.")
        case "storage": text = L("无法访问钥匙串，请解锁设备后重试。", "Keychain is unavailable. Unlock the device and try again.")
        case "invalid_image", "image_upload": text = L("图片无法发送，请重新选择后重试。", "Choose the image again and retry.")
        case "message_too_long": text = L("消息最多可包含 1000 个字符。", "Messages can contain up to 1,000 characters.")
        case "disconnect_timeout": text = L("断开超时，请在系统 VPN 设置中确认状态。", "Disconnection timed out. Check the status in VPN settings.")
        case "response": text = L("服务返回异常，请重试。", "The service sent an unexpected response. Try again.")
        default:
            if status == 429 { text = L("操作太频繁，请稍后重试。", "Too many requests. Try again shortly.") }
            else if status == 401 { text = L("身份验证失败，请检查登录信息。", "Authentication failed. Check your sign-in details.") }
            else { text = L("操作失败", "Request failed") + " (\(code))." }
        }
        if let suggestion { return text + " " + L("是否想输入", "Did you mean") + " \(suggestion)?" }
        if let retryAfter, status == 429 { return text + " \(retryAfter)s" }
        return text
    }
}
