# SunShadowPad App Store 发行检查单

## 开发配置

- [ ] 在 macOS 最新 Xcode 中打开 `SunShadowPad.xcodeproj`。
- [ ] 将 Bundle ID `com.sunshadowpad.local` 换成你的唯一值（反向域名格式），配置开发者 Team、证书和 Provisioning Profile。
- [ ] 在 Signing & Capabilities 中确认未启用 Push Notifications、In-App Purchase、Sign in with Apple 等本项目不需要的能力。
- [ ] 将 `SunShadowPad/Utilities/AppInfo.swift` 中的占位品牌信息替换为真实信息：
  - `developer` → 真实开发者/公司名称；
  - `supportEmail` → 可收信的客服邮箱；
  - `copyright` → 真实年份与主体；
  - 同步检查 About Us、Privacy Policy、User Agreement 三个页面的联系信息。
  - 占位邮箱下 App 会自动隐藏邮件链接并提示到 App Store 产品页查看联系方式，不会产生死链；但送审前仍必须配置真实可收信邮箱。
- [ ] 运行 `⌘B`、`⌘R`、`⌘U`（Debug 与 Release 各构建一次）。
- [ ] 确认 `SunShadowPad/Resources/PrivacyInfo.xcprivacy` 在 Copy Bundle Resources 中，内容为不跟踪、不收集、`UserDefaults` 理由 `CA92.1`，与实际数据行为一致。
- [ ] 在最小屏 iPhone（SE 或相近宽度）与主流尺寸检查安全区、标签、键盘和滚动。
- [ ] 在设置 → 辅助功能 → 更大字体下检查 4 个 Tab 与 Scene Editor：无截断、无重叠、主要操作可滚动到达。
- [ ] 安装到真实 iPhone，测试 Canvas 拖拽、双指缩放、批量对象、播放动画与后台恢复。
- [ ] 在真实 iPhone 上验收 3D：拖拽空白地面可环绕视角、双指缩放有上下限、拖动物体可移动且不会误触发环绕、Plan/3D 切换后选中对象与时间滑块状态一致、3D 拖动后撤销可用。
- [ ] 在低端真机上检查 3D 帧率与发热：大场景（28×18 米以上、多物体）连续播放一天阴影时不明显掉帧。
- [ ] 检查 AppIcon 1024×1024 无透明通道，不与已上架相似图标或商标混淆。

## 功能验收

- [ ] 首次进入三个样例可编辑、修改后重启保留。
- [ ] Scenes 中点击任意卡片的空白处、缩略图或标题都能直接进入对应场景的 Simulator；点击铅笔进入编辑器；归档卡片点击进入编辑器并可直接 Restore。
- [ ] Simulator 标题旁的铅笔能打开当前场景的编辑器；编辑器右上角太阳按钮保存并返回 Simulator。
- [ ] 新建 → 添加障碍物 → 设置目标 → 模拟 → Timeline → 修改布局 → Compare → PDF 一次闭环。
- [ ] 手动以不同经纬度、时区和北向核对太阳角度/阴影方向。
- [ ] DST 切换、极昼极夜、零高度、重叠阴影与大场景性能测试。
- [ ] JSON 单个/批量导出与导入，重复 ID 处理、非法 JSON 提示、删除资料与备份恢复。
- [ ] PDF 可从 Files 打开、打印/分享，PNG 可以被 Photos 或 Files 读取。
- [ ] 键盘在点击非输入区域时收起；文字输入框点击时可正常输入。
- [ ] 设置中的 12/24 小时制与米/英尺展示有效。
- [ ] 飞行模式下建模、模拟、导出全部可用（App 不发起网络请求）。

## 商店信息与合规

- [ ] 提供真实的开发者名称、Support URL 和可收信的联系邮箱（不得使用占位内容送审）。
- [ ] 发布可公开访问的 HTTPS **Privacy Policy URL**，内容与 App 内政策一致。
- [ ] 确认 App 不依赖账号、不访问定位、不集成广告追踪、无推送、无内购，并按实际版本填写 App Privacy 问卷；问卷答案应与随包 `PrivacyInfo.xcprivacy` 一致。
- [ ] 在 App Store Connect 填写年龄分级（建议 4+）、类别（Utilities 或 Productivity）、版权与加密出口合规（`ITSAppUsesNonExemptEncryption=false`）。
- [ ] App Store 截图与描述来自**实际构建**，不以示意图替代真实截图；建议准备 6.9" 与 6.5" 两套。
- [ ] 检查 Apple Guidelines 2.1（完整）、4.2（功能）、4.3（重复）、5.1（隐私）。
- [ ] 对阴影、日照数值使用“estimate / theoretical / planning aid”措辞，不承诺工程认证或真实天气结果。
- [ ] 通过 TestFlight 发布测试版并回归导出/恢复流程，然后再提交审核。

## 可重复的验证命令

```sh
python3 tools/generate_project.py
xcodebuild -project SunShadowPad.xcodeproj -scheme SunShadowPad \
  -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 18 Pro' \
  -derivedDataPath build CODE_SIGNING_ALLOWED=NO build
xcodebuild -project SunShadowPad.xcodeproj -scheme SunShadowPad \
  -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 18 Pro' \
  -derivedDataPath build CODE_SIGNING_ALLOWED=NO test
xcodebuild -project SunShadowPad.xcodeproj -scheme SunShadowPad \
  -configuration Release -destination 'generic/platform=iOS' \
  -derivedDataPath build-release CODE_SIGNING_ALLOWED=NO build
```

如模拟器名称不同，先用 `xcrun simctl list devices available` 查询。真实结果见 `Docs/VALIDATION_REPORT.md`。

官方政策：https://developer.apple.com/app-store/review/guidelines/
