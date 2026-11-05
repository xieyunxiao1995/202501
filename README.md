# SunShadowPad — iPhone SwiftUI Project

一个可直接用 Xcode 打开的离线日照模拟与布局比较工具。随包提供完整中文产品/UI/架构规范、英文 iPhone UI、可编辑示例场景、可拖动旋转的 SceneKit 3D 建模视图与平面视图切换、SwiftData 本地持久化、太阳与阴影引擎、日照时间线与热力图、布局对比、PDF/PNG/JSON 导入导出、设置/帮助/协议/反馈页，以及 XCTest 单元测试与 XCUITest 交互测试。

## 一键打开

1. 将 ZIP 解压到 Mac 的普通可写目录，不要只在压缩包预览中打开文件。
2. 双击 **`SunShadowPad.xcodeproj`**，或在 Xcode 中使用 **File → Open** 选择该文件。
3. 选择 `SunShadowPad` Scheme，再选择 iPhone Simulator（iOS 17 或更高）。
4. 按 `⌘B` 编译，按 `⌘R` 运行。模拟器上无需填写 Team；真机安装/上架需要你自己的开发者证书和签名设置。
5. 运行测试（Xcode 的 Product → Test / `⌘U`）：`SunShadowPadTests` 为算法回归，`SunShadowPadUITests` 为卡片点击与编辑/模拟器往返的界面测试。

**最低平台**：iOS 17；**布局方向**：iPhone portrait；**语言**：English；**依赖**：零第三方 SDK；**网络**：核心功能无网络调用。

## 第一次打开后的路径

点击 **Courtyard Garden** 卡片直接进入 Simulator（卡片任意位置可点，带 “Current” 标记）→ 编辑器（卡片铅笔或 Simulator 标题旁的铅笔）→ 3D 视图中拖动物体建模（或点右下角切换 Plan 平面视图）→ Add Object（Wall / Building / Tree / Canopy）→ 选中属性，修改 Height → 添加 Vegetable Bed → 用编辑器右上角太阳按钮回到 Simulator 调整日期和时间（3D 视图单指旋转、双指缩放）→ Timeline 查看 Day / Heatmap → Scenes 中 Duplicate as New Layout → 修改副本 → Timeline → Compare → 导出 PDF。

## 文件结构

```text
SunShadowPad.xcodeproj/             Xcode 工程
SunShadowPad/App/                  App 入口、共享状态、引导
SunShadowPad/Models/               SwiftData 和 Codable 模型
SunShadowPad/Services/             太阳、阴影、曝光、备份、导出
SunShadowPad/UI/                   完整 SwiftUI 四 Tab 界面
SunShadowPad/Resources/            Info.plist + 1024px AppIcon
SunShadowPadTests/                 XCTest 算法回归
SunShadowPadUITests/               XCUITest 卡片点击 / 编辑器往返
Docs/SunShadowPad_功能UI与代码架构规范.md
Docs/RELEASE_CHECKLIST.md
Docs/VALIDATION_REPORT.md
Docs/APP_STORE_SUBMISSION.md
tools/generate_project.py          可重新扫描 Swift 文件并生成 PBXGroup 工程
```

## 核心模型约束

本应用的数值是**理论太阳直射 + 水平地面几何遮挡**的近似值。太阳计算采用 NOAA 简化方程，不是完整 NREL SPA。它不考虑云、地形、未知建筑、树冠透明度或专业日照测量标准，不能作为建筑合规认证、植物生长保证或安全工程报告。

## 发布前必须做的事

- 更换 Xcode Build Settings 中默认 `com.sunshadowpad.local` Bundle ID，并设置真实 Apple Developer Team。
- 将 `SunShadowPad/Utilities/AppInfo.swift` 中的占位信息（Independent Developer / support@example.com）替换为提交者的真实开发者名称与可用邮箱。
- 为 App Store Connect 填写真实的公共隐私政策网页、支持网页、发行主体信息，以及真实截图。界面已内置隐私文本，但 Apple 仍要求公开可访问的 URL。
- 核对 App Store Review Guidelines 2.1、4.2、4.3 与 5.1；不要将本工程视为审核批准的承诺。
- 完整检查单见 `Docs/RELEASE_CHECKLIST.md`，商店文案与隐私问卷建议见 `Docs/APP_STORE_SUBMISSION.md`。

## 已完成的验证

- Xcode 27.0 / iOS 27 SDK：Debug 与 Release 均 `BUILD SUCCEEDED`。
- iPhone 18 Pro 模拟器：27 项单元测试与 4 项 XCUITest 全部通过，含太阳方位、阴影长度、DST、极昼极夜、季节代表日、JSON 往返、非法输入、热力图点击映射、3D 世界坐标/太阳方向/旋转/相机/边界夹取、`PrivacyInfo.xcprivacy` 内容与提交配置，以及 PDFKit 对 3 页与 4 页报告的文本校验；界面测试覆盖卡片与列表行点击进入 Simulator、编辑器太阳按钮回到 Simulator，以及 Simulator 铅笔打开编辑器。
- 模拟器走查：引导页、Scenes、Simulator（默认 3D）、Timeline（Day/Heatmap/Seasons/Compare）、Settings、Editor 3D 模式；3D 场景显示实时太阳光照与真实投影阴影、地面网格与真北罗盘、选中高亮，支持单指旋转、双指缩放及编辑器内拖动建模；Accessibility XL 字号下 Scenes、Simulator、Timeline 与 Compare 均改为自适应布局。
- 随包提供 `PrivacyInfo.xcprivacy`：不跟踪、不收集数据，仅声明 `UserDefaults` 的 `CA92.1` 用途。

详细命令、截图路径与尚未执行的项目见 `Docs/VALIDATION_REPORT.md`。

## 版本/许可证提示

App 图标是本交付单独生成的原创视觉素材。用户应在正式发布前核查图标独占性、商用使用条件及 Apple 资产格式。此仓库未附加需要许可证管理的第三方依赖。
