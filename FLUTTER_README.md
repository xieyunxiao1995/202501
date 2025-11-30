# 心屿 MindFlow - Flutter 日记应用

一个基于"记忆牌桌"概念的沉浸式日记应用，采用扑克牌交互设计，让记录和整理记忆成为一种享受。

## ✨ 核心特性

### 🎴 记忆牌桌系统
- **卡片式日记**: 每篇日记都是一张精美的卡片，支持翻转查看AI洞察
- **智能堆叠**: 将相关日记叠在一起，形成"人生篇章"
- **一键整理**: AI自动按心情分类整理日记
- **情绪可视化**: 4种心情色彩（开心/平静/焦虑/忧郁）

### 🤖 AI 伴侣
- 基于 DeepSeek API 的智能对话
- 自动分析日记情绪并生成洞察
- 温暖的对话体验，帮助整理思绪

### 🌍 广场功能
- 分享公开日记（拍立得风格）
- 浏览他人的心情记录
- 互动点赞支持

### 🎨 沉浸式设计
- **暖调书房主题**: 暖岩灰背景 + 云峰白卡片
- **纸张纹理**: 柏林噪点模拟真实质感
- **物理阴影**: 3D厚度感，卡片悬浮效果
- **流畅动画**: 翻转、堆叠、发牌动画

## 🏗️ 技术架构

### 状态管理
- 使用 `setState` 进行简单状态管理
- 无需复杂的状态管理库

### 数据持久化
- `shared_preferences` 本地存储
- JSON 序列化/反序列化

### AI 集成
- DeepSeek Chat API
- 情绪分析和洞察生成
- 智能对话历史管理

### UI 组件
- 自定义卡片翻转动画
- 手势交互（长按、拖拽、滑动）
- 毛玻璃导航栏
- 自定义 CustomPainter（噪点、图案）

## 📦 依赖包

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  http: ^1.2.0              # API 请求
  shared_preferences: ^2.2.2 # 本地存储
  intl: ^0.19.0             # 日期格式化
  image_picker: ^1.0.7      # 图片选择
```

## 🚀 快速开始

### 1. 安装依赖
```bash
flutter pub get
```

### 2. 配置 API Key
在 `lib/services/deepseek_service.dart` 中配置你的 DeepSeek API Key：
```dart
static const String apiKey = 'your-api-key-here';
```

### 3. 运行应用
```bash
flutter run
```

### 4. 代码检查
```bash
flutter analyze
```

## 📁 项目结构

```
lib/
├── main.dart                 # 应用入口
├── constants/
│   ├── app_colors.dart      # 颜色配置
│   └── sample_data.dart     # 示例数据
├── models/
│   ├── diary_entry.dart     # 日记条目模型
│   ├── card_stack.dart      # 卡片堆叠模型
│   ├── chat_message.dart    # 聊天消息模型
│   └── square_post.dart     # 广场帖子模型
├── pages/
│   ├── home_page.dart       # 主页（记忆牌桌）
│   ├── companion_page.dart  # AI伴侣页
│   ├── square_page.dart     # 广场页
│   ├── settings_page.dart   # 设置页
│   └── editor_page.dart     # 编辑器页
├── services/
│   ├── deepseek_service.dart # DeepSeek API服务
│   └── storage_service.dart  # 本地存储服务
└── widgets/
    ├── bottom_nav.dart      # 底部导航栏
    └── diary_card.dart      # 日记卡片组件
```

## 🎨 设计理念

### 配色方案
- **全局背景**: `#E8E4D9` (暖岩灰)
- **卡片正面**: `#F9F7F2` (云峰白)
- **卡片背面**: `#D4C5B0` (拿铁色)
- **文字颜色**: `#4A4238` (深褐)

### 情绪色彩
- **开心**: `#E9C46A` (姜黄)
- **平静**: `#2A9D8F` (波斯绿)
- **焦虑**: `#E76F51` (铁锈红)
- **忧郁**: `#457B9D` (钢蓝)

## 🔧 开发规范

### 代码风格
- 使用 `flutter_lints` 进行代码检查
- 所有文件通过 `flutter analyze` 无警告
- 使用 `withValues(alpha:)` 替代已废弃的 `withOpacity()`
- 使用 `developer.log()` 替代 `print()`

### 命名规范
- 文件名: `snake_case`
- 类名: `PascalCase`
- 变量/方法: `camelCase`
- 私有成员: `_leadingUnderscore`

## 📝 功能清单

- [x] 日记卡片展示与翻转
- [x] AI 情绪分析与洞察
- [x] 智能堆叠与整理
- [x] AI 对话伴侣
- [x] 广场分享功能
- [x] 本地数据持久化
- [x] 图片附件支持
- [x] 隐私控制（公开/私密）
- [ ] 夜间模式（深空主题）
- [ ] 数据导出功能
- [ ] 通知提醒
- [ ] 扇形预览手势
- [ ] 拖拽堆叠交互

## 🐛 已知问题

无

## 📄 许可证

本项目仅供学习和个人使用。

## 🙏 致谢

- UI 设计灵感来自经典纸牌游戏"空档接龙"
- AI 能力由 DeepSeek 提供
- Flutter 框架及社区
