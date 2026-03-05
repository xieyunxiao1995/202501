# 游戏项目开发规范
- **核心约束**：这是一款纯前端模拟的独立游戏。不需要账户系统，不需要外部字体和 google_fonts，禁止使用 share_plus。
- **状态管理**：严格、仅使用原生的 `setState`，不要引入 Provider、Riverpod 或 GetX。
- **数据存储**：使用 `shared_preferences` 进行数据持久化。
- **数据模型**：手写普通的 Dart class，禁止使用 `freezed` 包和 `part` 语法。
- **UI & 资源**：
  - 图标全部使用 Flutter 自带的 `Icons`（Material Icons）。
  - 所有图片仅使用 `Image.network` 加载网络 URL（如 dicebear API 或 transparenttextures）。
  - 不需要本地 `assets/images/`，禁止引入 `cached_network_image`。
- **参考代码**：游戏的业务逻辑、数值公式（如战斗力 CP 计算、伤害计算公式）、抽卡概率和基础 UI 结构，请参考根目录的 `index.html`以及 README.md 中的说明）。