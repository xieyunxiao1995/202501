# CPDD小屋 穿搭 App 设计架构文档

## 1. 产品定位

CPDD小屋 是一款仅面向 iOS 的个人穿搭记录与智能购物辅助 App。它把每日穿搭、个人衣橱和 DeepSeek AI 助手放在同一套轻量本地体验中，不需要账户即可使用。

首版目标：让用户能够用照片记录穿搭与衣物，快速回顾自己的衣橱，并基于真实衣橱和近期穿搭获得搭配、购物及衣物养护建议。

## 2. 范围与约束

- 仅支持 iOS。
- 状态管理使用 `setState`。
- 结构化数据使用 `shared_preferences` 保存为 JSON。
- 图片只从系统相册选择，并复制到应用文档目录持久化。
- 不提供账户、账号密码、注册、云同步或社交功能；启动时使用不创建账户的 EULA 同意登录门槛，详见 `2026-06-21-onboarding-eula-design.md`。
- 不使用 `freezed`、代码生成、`part`、`cached_network_image`、`google_fonts`、`share_plus`。
- 不使用外部字体，采用 iOS 系统字体。
- DeepSeek API Key 放在项目独立配置文件中。此方案仅适合内部测试；发布包中的密钥可被提取，正式发布前必须迁移至服务端代理。

## 3. 信息架构

应用使用四栏底部导航：

1. **穿搭日记**：双列卡片展示穿搭记录，支持新增、查看、编辑和删除。
2. **我的衣橱**：双列卡片展示衣物，支持分类筛选、新增、编辑和删除。
3. **AI 助手**：结合本地衣橱和近期穿搭提供穿搭、购物与养护建议。
4. **设置**：数据统计、清空本地数据以及信息与支持入口。

设置页的以下功能分别使用独立 Dart 页面：

- 关于我们
- 用户协议
- 隐私协议
- 使用帮助
- 反馈与建议

## 4. 视觉设计

整体采用“轻盈时尚手账”方向：白色作为主画布，背景叠加低饱和雾蓝与浅粉渐变光晕，主按钮使用明快蓝色。卡片采用 20–28pt 圆角、克制阴影和较大的留白，避免通用模板感。

核心规范：

- 主色：`#3978F6`
- 深色正文：`#172033`
- 次级文字：`#6F7890`
- 雾蓝背景：`#EEF5FF`
- 浅粉背景：`#FFF1F6`
- 危险色：`#E45865`
- 系统字体：San Francisco（由 iOS 自动提供）
- 最小可点击区域：44×44pt

原创位图资产放入 `assets/images/`：

- `wardrobe_empty.png`：衣橱空状态插画
- `outfit_empty.png`：穿搭日记空状态插画
- `ai_assistant_header.png`：AI 助手顶部氛围插画
- `app_about.png`：关于我们品牌插画

素材统一使用白底、雾蓝与浅粉、服装线稿和柔和纸张质感，不在位图内生成文字。按钮、图标和背景渐变由 Flutter 原生绘制。

## 5. 数据模型

### OutfitEntry

- `id`
- `imagePath`
- `title`
- `date`
- `occasion`
- `mood`
- `notes`
- `clothingItemIds`

### ClothingItem

- `id`
- `imagePath`
- `name`
- `category`
- `color`
- `season`
- `isPurchased`
- `careNotes`
- `createdAt`

### ChatMessage

- `id`
- `role`（user/assistant）
- `content`
- `createdAt`
- `isError`

每个模型手写 `toJson`、`fromJson` 和 `copyWith`，不使用代码生成。

## 6. 应用架构

采用轻量 feature-first 结构：

```text
lib/
  app/
    app.dart
    app_theme.dart
  config/
    deepseek_config.dart
  models/
  services/
    local_storage_service.dart
    image_storage_service.dart
    deepseek_service.dart
  pages/
    shell_page.dart
    outfits/
    wardrobe/
    assistant/
    settings/
  widgets/
```

页面通过 `setState` 管理瞬时 UI 状态。`ShellPage` 持有穿搭和衣橱列表，并将变更回调传给子页面；每次增删改后立即写入 `shared_preferences`。服务层隔离持久化、图片复制和网络请求，便于测试。

## 7. 数据流

### 新增记录

1. 用户打开编辑页并从相册选择图片。
2. `image_picker` 返回临时路径。
3. `ImageStorageService` 将图片复制到应用文档目录。
4. 页面构建模型并通过回调交给 `ShellPage`。
5. `ShellPage` 调用 `setState` 更新列表，并异步持久化 JSON。

### AI 请求

1. 用户点击快捷问题或输入问题。
2. 页面收起键盘并追加用户消息。
3. `DeepSeekService` 将衣橱摘要、近期穿搭摘要、购物与养护规则拼入 system prompt。
4. 调用 DeepSeek OpenAI 兼容接口。
5. 成功时追加助手消息；失败时展示可重试的错误消息并保留原问题。

## 8. DeepSeek 助手行为

系统提示词要求助手：

- 优先使用用户已经拥有的衣物给出搭配。
- 购物建议要说明衣橱缺口、复用场景和不购买的替代方案。
- 不虚构用户衣橱中不存在的单品。
- 提供面料与衣物养护建议时标明通用建议，提醒用户优先查看洗标。
- 回答简洁、具体、可执行，并使用中文。

预设问题包括：

- 今天穿什么？
- 我的衣橱缺什么基础款？
- 这件单品值得买吗？
- 给我一个一周搭配思路
- 衣服换季怎么收纳？
- 不同面料应该怎么养护？

## 9. 交互与错误处理

- 首页与衣橱均使用稳定双列网格；空数据时显示原创插画与主行动按钮。
- 表单必填项缺失时就地提示。
- 图片损坏或不存在时显示原生渐变占位。
- 删除记录需要确认；清空全部数据使用危险操作确认框。
- AI 请求显示发送中状态，禁止重复发送；网络错误提供重试。
- 页面根节点使用点击手势统一收起键盘，快捷问题、消息区、导航栏和空白区域均不保留键盘焦点。
- 反馈页提供分类、内容和可选联系方式，优先通过 `mailto:` 打开系统邮件；无法打开时允许复制反馈内容。

## 10. 隐私与权限

- 只申请相册读取权限，不申请相机权限。
- 用户数据默认仅保存在本机。
- 发送 AI 问题时会把衣橱和近期穿搭的文字摘要发送给 DeepSeek，但不上传本地图片。
- 隐私协议中明确说明本地存储、AI 数据传输和清空数据行为。

## 11. 测试与验收

- 模型 JSON 往返测试。
- 本地存储读写测试。
- DeepSeek 请求体和上下文摘要测试。
- 四栏导航与核心页面 Widget 测试。
- 快捷问题发送和点击非输入区域收起键盘测试。
- `flutter analyze` 无错误。
- `flutter test` 全部通过。
- `flutter build ios --simulator` 构建成功。
