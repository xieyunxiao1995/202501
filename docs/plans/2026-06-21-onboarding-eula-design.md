# CPDD小屋 启动轮播与 EULA 登录设计

## 1. 目标

为 CPDD小屋 增加每次启动必经的品牌引导流程：先用四屏画册式轮播介绍产品能力与生活意境，再通过无账号、无密码的 EULA 同意页面进入主 App。

这里的情绪表达用于营造穿衣与生活的氛围，不新增心情量化、心情追踪或用户画像功能。

## 2. 启动流程

```text
iOS 系统启动画面
→ 四屏 Onboarding 轮播
→ EULA 登录页
→ EULA 独立阅读页
→ 用户主动勾选同意
→ 登录并进入 ShellPage
```

- 每次冷启动都重新显示完整流程。
- 不保存 onboarding 完成状态或登录状态。
- 轮播右上角提供“跳过”，直接进入 EULA 登录页。
- 未勾选 EULA 时，“登录并进入”按钮保持禁用。
- 打开并阅读 EULA 不会自动勾选同意，必须由用户主动操作。
- 不提供账号、密码、验证码、注册、找回密码或第三方登录。

## 3. 轮播页面

轮播使用原生 `PageView`，共四屏：

1. **把穿搭，写成生活的注脚**
   - 介绍穿搭日记。
   - 画面使用穿搭手账、衣架与柔和纸张意象。

2. **看见衣橱真正的秩序**
   - 介绍双列衣橱记录和分类整理。
   - 画面使用晨光下的衣橱与有秩序的服装轮廓。

3. **少买一点，更会搭一点**
   - 介绍 AI 穿搭、理性购物和衣物养护建议。
   - 画面表达衣物与购物袋之间克制、清醒的关系。

4. **每一次选择，都更接近自己**
   - 表达本地记录、日常风格和进入 App 的邀请。
   - 画面使用衣物、纸张与柔和晨光营造安静意境。

每屏包含原创插画、英文小标签、中文主标题、短说明、页码指示和下一步按钮。文字由 Flutter 原生渲染，不写入位图。

## 4. 登录与 EULA

### EULA 登录页

- 标题：“欢迎回来”
- 说明：“不需要账号，确认许可协议后即可进入你的私人衣橱。”
- 提供可点击的 EULA 协议名称。
- 提供独立勾选框：“我已阅读并同意《最终用户许可协议》”。
- 主按钮：“登录并进入”
- 未勾选时按钮禁用；勾选后可进入 `ShellPage`。

### EULA 独立页面

使用单独 Dart 文件，包含：

- 许可授权范围
- 用户内容和合法使用
- 禁止行为
- AI 输出与责任边界
- 本地数据与第三方服务
- 知识产权
- 免责声明与终止
- 协议版本和更新日期

EULA 页面只负责阅读，不改变同意状态。

## 5. 视觉方向

延续 CPDD小屋 的雾蓝、浅粉、白色和深墨色体系，并强化“轻盈时尚画册”感：

- 大面积留白和不完全居中的插画构图。
- 插画局部越界，形成杂志版式感。
- 主标题使用 iOS 系统字体的高字重与紧凑字距。
- 页码和英文标签使用较大字间距。
- 按钮维持蓝色，登录页使用少量深色卡片增强仪式感。
- 切页时文字淡入、插画轻微位移；遵循系统“减少动态效果”设置。

新增原创素材：

```text
assets/images/onboarding/journal.png
assets/images/onboarding/wardrobe.png
assets/images/onboarding/assistant.png
assets/images/onboarding/identity.png
```

## 6. 架构

```text
lib/pages/launch/
  launch_flow_page.dart
  onboarding_page.dart
  consent_login_page.dart
  eula_page.dart
  onboarding_slide.dart
```

- `CpClothApp` 的首页改为 `LaunchFlowPage`。
- `LaunchFlowPage` 只在内存中持有 onboarding/login/app 三种状态。
- `OnboardingPage` 通过回调通知跳过或完成。
- `ConsentLoginPage` 通过回调通知本次 EULA 已同意。
- 完成后创建现有 `ShellPage`，不改动主业务数据结构。

## 7. 可访问性与错误处理

- 所有按钮和协议链接至少 44pt。
- 页面支持 Dynamic Type，并在大字号下可滚动。
- 图片加载失败时显示原生渐变与图标，不阻止继续。
- PageView 提供语义标签和当前页信息。
- 禁用登录按钮时，协议区域仍明确说明需要勾选。
- 不使用输入框，因此流程不会主动弹出键盘。

## 8. 测试与验收

- 启动时显示第一屏 onboarding，而不是主 App。
- “跳过”能进入 EULA 登录页。
- 下一页能依次切换四屏。
- 最后一屏能进入登录页。
- 未勾选 EULA 时无法进入主 App。
- 点击协议打开独立 EULA 页面，返回后仍未自动同意。
- 勾选后可进入包含四栏导航的主 App。
- 重新创建 App Widget 时再次从第一屏开始。
- `flutter analyze`、`flutter test` 和 `flutter build ios --simulator` 全部通过。

