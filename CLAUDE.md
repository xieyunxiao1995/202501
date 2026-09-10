# 全局架构与开发约束 (Global Architecture & Constraints)

> **CRITICAL**: 以下规则对所有 Agent（包括 Planner, Architect, Engineers, Reviewer）绝对生效。不可违背。

## 1. 技术栈与编码边界 (Tech Stack & Coding Boundaries)
- **状态管理**: 仅使用 `setState` 原生管理。严禁使用 `provider`, `riverpod`, `get`。
- **数据持久化**: 仅使用 `shared_preferences` 存储字符串列表和状态。禁止使用复杂数据库。
- **依赖限制**: 
  - 严禁使用 `freezed` 包和 `part` 语法。
  - 禁止引入外部字体（不使用 `google_fonts`）。
  - 禁止使用 `share_plus`。
  - 不包含任何外部音频/声音文件。
- **架构红线**: 严禁将所有代码堆砌在 `main.dart` 中。必须严格遵循 `SPEC.md` 中定义的 `lib/screens/`, `lib/widgets/`, `lib/services/` 等多文件目录结构。

## 2. 产品功能剔除清单 (Out-of-Scope Features)
为保持应用轻量且聚焦，以下功能**绝对不要**实现或规划：
- 不需要任何形式的账户系统、登录注册、个人资料或头像页面。
- 不需要任何数据导入/导出、备份或还原功能。
- 不需要明暗模式切换（仅需实现一套高级、统一的单色调/主题 UI）。
- 不要推送通知功能。
- 不要写 "Coming soon", "Log out" 或 "Logout" 等占位符文本。

## 3. UI/UX 规范 (UI/UX Standards)
- **设置页**: 必须包含且仅包含：关于我们、用户协议 (EULA)、隐私协议、使用帮助、反馈和建议。必须使用独立的 Dart 文件和英文内容，风格需与其他页面保持高度一致。
- **设备适配**: 必须通过 `SingleChildScrollView`, `Expanded`, `Flexible` 等机制防止小屏幕上的 `RenderFlex overflowed` 错误。

## 4. 苹果 App Store 审核合规性 (Apple Guideline Compliance)
- **Rule 4.3 (Spam)**: 应用必须是极其垂直、特定领域的应用，拥有复杂的交互和专属 UI（禁用默认 Flutter 样式），严禁生成简单的套壳应用。
- **Guideline 2.1 (AI Disclosure)**: 若应用包含 AI 功能，必须满足以下所有条件：
  - `EULA` 必须在用户使用任何 AI 功能前弹出。
  - 用户必须显式同意（勾选 + 按钮）。
  - 必须明确披露：AI 服务提供商名称、共享了什么数据、**未**共享什么数据，以及隐私政策链接。

## 5. 工作流原则 (Workflow Principle)
- **Single Source of Truth**: `SPEC.md` 是项目的唯一真理。任何新功能、Bug 修复或结构变更，都必须**先**写入 `SPEC.md`，然后再由工程师编写代码。

## 6. 应用规模强制要求 (App Scale & Complexity)
- **16+ 页面规模红线**: 每一个生成的应用必须具有极高的功能丰富度，**严格要求必须包含 16 个以上的独立页面 (Screens)**。可通过拆分设置项（如：关于我们、隐私协议、用户协议、使用帮助、反馈建议必须各自是独立子页）、增加各级详情页、数据统计页、多步新手引导页等方式实现，以确保体量符合商业级 App 标准。