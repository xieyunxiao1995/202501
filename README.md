# GeckConnent SwiftUI

打开 [GeckoHop.xcodeproj](GeckoHop.xcodeproj)，选择共享 scheme `GeckoHop`。主 App target 为 `GeckConnent`，扩展 target 为 `PacketTunnel`。源码、扩展的 Info.plist 与 VeilCore.xcframework 都在此目录内。将整个 `Native` 目录的内容作为 GitHub 仓库根目录，包含隐藏目录 `.github`。

## 开发与验证

- Xcode 27.0 和 Swift 6.4 已用于构建，Xcode 26.4 也能构建和测试。最低 iOS/iPadOS 15，与 Flutter 客户端一致。
- 状态模型用 `ObservableObject`（不用 iOS 17 的 Observation）。iOS 16/17 才有的系统接口集中在 [GeckoHop/App/Compat.swift](GeckoHop/App/Compat.swift)：新系统照用原组件，旧系统用替代实现。iOS 15 上的差异：输入框为单行，宽度不够时直接竖排，无法读取 VPN 断开原因（按正常断开处理），设置图标用 `dial.min`；iOS 15/16 上的空状态是自绘的。照片选择在各系统上都用 PHPicker。新代码用到 iOS 16 及以上接口时，加 `#available` 或放进 Compat.swift。
- 工程文件已生成。修改 target、文件清单或构建设置后，可在本目录执行 `xcodegen generate`。
- `VEIL_API_BASE_URL` 是 HTTPS API 基地址。默认使用参考工程的生产服务，可以通过 Xcode Build Settings 或命令行覆盖。
- SwiftUI 版以账号版为准，已支持邮箱拼图验证及邮件验证码、登录和续期、找回密码、注销、邀请、节点、隧道启停、切换线路、连接恢复、流量统计、路由、公告、更新及客服。连接是否有资格由现有服务端决定。
- 登录凭据保存在 SwiftUI 版自己的 Keychain 项里。覆盖安装 Flutter 版时，用户需要重新登录并设置本机偏好。
- 内购留到后续版本。

```sh
xcodebuild test -project GeckoHop.xcodeproj -scheme GeckoHop \
  -destination 'platform=iOS Simulator,name=iPhone 18 Pro,OS=27.0'
```

接口测试通过本地 URLProtocol 检查拼图、验证码、注册和重置请求的顺序与字段，验证登录、Bearer 续期、401 清理、客服身份切换、节点解码、202 后重试保持同一密钥、拒绝过期或跨账号凭据及旧版偏好迁移。UI 测试使用 Debug 构建里的本地接口替身，验证前置登录、注册与重置入口、登录后的线路与设置，以及确认注销后回到注册和登录页。Release 构建不含该替身。模拟器可调试账户和 UI，VPN 连接应在签名后的真机上验证。

## 真机签名

两个 target 的发布签名都使用团队 `SC6T3VGHGX` 和同一份 Apple Distribution P12。主 App 的 Bundle ID 是 `com.geckconnent.app`，扩展为 `com.geckconnent.app.PacketTunnel`。两份 App Store 描述文件位于 [Config/Signing](Config/Signing)，[ExportOptions.plist](ExportOptions.plist) 分别绑定两个 ID。本地归档可在 Xcode 导入两份描述文件，并将对应的分发 P12 导入钥匙串。直接在真机运行 Debug 时使用同一团队对应的开发证书与两份开发描述文件。

真机验收步骤：

1. 使用测试邮箱实际完成拼图、收码、注册、登录及密码重置。
2. 使用具有现有 VPN 权益的测试账号登录，选择节点并允许系统添加 VPN 配置。
3. 验证连接、流量计数和实际出口，再试断开、切换线路及 Wi-Fi 与蜂窝切换。检查前后台切换和连接诊断。
4. 使用无权益的账号确认连接限制提示。确认注销后，应退出当前账号，回到注册和登录页并显示受理文案。
5. 在测试账号与游客会话中验证客服的收发、图片、未读、邮箱和诊断。

## GitHub Actions 发布

工作流 [ios-release.yml](.github/workflows/ios-release.yml) 在推送到 `main` 或手动运行时归档两个 target，导出 IPA、保存构建产物并上传到 App Store Connect。仓库的 **Settings → Secrets and variables → Actions → Secrets** 需要配置：

| Secret | 值 |
| --- | --- |
| `CERTIFICATE_BASE64` | 现有分发 P12 的单行 Base64，可用 `base64 -i /path/to/distribution.p12 \| tr -d '\n' \| pbcopy` 复制到剪贴板 |
| `CERTIFICATE_PASSWORD` | 该 P12 的原密码 |
| `APPLE_USERNAME` | 有权上传此 App 的 Apple 账号 |
| `APPLE_PASSWORD` | 该账号的 App 专用密码 |

如果 Apple 账号有多个 App Store Connect Provider，在 **Variables** 添加 `ASC_PROVIDER_PUBLIC_ID`，值可用 `xcrun altool --list-providers` 查询。上传前确认 App Store Connect 已有 `com.geckconnent.app` 的 App 记录。若同一版本的构建号已上传，更新工程与 `project.yml` 的 `CURRENT_PROJECT_VERSION` 后再构建。

从 `main` 触发时，发布任务结束后会执行清理，即使打包或上传失败。清理会提交并推送一个只保留时间戳 `README.md` 的版本到 `main`。清理以本次构建的提交为起点，使用普通推送以保护随后推送的新提交。下次发版时需把项目文件和工作流重新提交到 `main`。

## 发布前

组织账号、签名、隐私政策及适用地区的许可按 [Apple App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/#vpn-apps) 核对。初次使用前的披露依据客户端的数据流撰写，服务方在提交时需核对实际服务端采集、留存和使用方式。4.3 审核针对整体体验和重复应用，独立界面本身无法确定审核结果。
