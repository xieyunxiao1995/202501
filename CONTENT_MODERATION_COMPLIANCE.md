# 内容审核合规性文档 (App Store Compliance)

## 概述
本文档说明应用如何符合 App Store 关于用户生成内容的审核要求。

## App Store 要求
根据 App Store 审核指南，包含用户生成内容的应用必须：
1. ✅ 提供用户屏蔽其他用户的机制
2. ✅ 屏蔽操作必须通知开发者
3. ✅ 屏蔽后立即从用户的 feed 中移除被屏蔽用户的内容
4. ✅ 提供举报不当内容的机制

## 已实现的功能

### 1. 用户屏蔽功能 (User Blocking)

#### 位置
- `lib/screens/creator_profile_screen.dart` - 用户资料页面
- `lib/services/data_service.dart` - 数据服务层

#### 功能说明
- 用户可以在任何创作者的资料页面点击"更多"按钮
- 选择"屏蔽此用户"选项
- 确认后，该用户的所有内容立即从 feed 中移除
- 屏蔽信息保存到本地存储
- **自动通知开发者**有用户被屏蔽

#### 代码实现
```dart
// 屏蔽用户
await _dataService.blockUser(userId);

// 通知开发者
await _dataService.notifyDeveloperOfBlock(
  blockedUserId: userId,
  blockedUsername: username,
  reason: '用户主动屏蔽',
);

// 立即从 feed 中移除内容
_posts = _dataService.filterBlockedUserPosts(_posts);
```

### 2. 内容举报功能 (Content Reporting)

#### 支持的举报类型
1. **用户举报** - 举报不当用户行为
2. **动态举报** - 举报不当帖子内容
3. **消息举报** - 举报不当聊天消息

#### 举报原因选项
- 垃圾信息
- 不当内容（色情、暴力等）
- 骚扰他人
- 虚假信息
- 侵犯版权
- 其他原因

#### 功能说明
- 所有举报都会保存到本地存储
- **自动通知开发者**有新的举报
- 高优先级举报（不当内容、骚扰、暴力）会被标记
- 用户会收到"我们将在24小时内审核"的确认消息

#### 代码实现
```dart
// 举报用户
await _dataService.reportUser(
  reportedUserId: userId,
  reportedUsername: username,
  reason: reason,
  reporterContext: {...},
);

// 通知开发者
await _dataService.notifyDeveloperOfReport(
  reportedUserId: userId,
  reportedUsername: username,
  reason: reason,
  contentType: '用户资料',
);
```

### 3. 开发者通知机制 (Developer Notifications)

#### 通知类型
1. **屏蔽通知** - 当用户屏蔽其他用户时
2. **举报通知** - 当用户举报内容时

#### 通知内容
- 被举报/屏蔽的用户ID和用户名
- 举报原因
- 时间戳
- 优先级（HIGH/MEDIUM）
- 内容类型

#### 当前实现
目前使用 `print()` 输出到控制台，便于开发和测试。

#### 生产环境建议
在生产环境中，应该将这些通知发送到：
- 后端 API 端点
- 管理员仪表板
- 邮件通知系统
- Slack/Discord webhook
- 推送通知服务

```dart
// TODO: 生产环境实现示例
Future<void> notifyDeveloperOfReport(...) async {
  // 发送到后端 API
  await http.post(
    Uri.parse('https://api.yourapp.com/moderation/report'),
    body: jsonEncode(notificationData),
  );
  
  // 发送邮件通知
  await emailService.sendAlert(
    to: 'moderation@yourapp.com',
    subject: 'Urgent: Content Report',
    body: jsonEncode(notificationData),
  );
}
```

### 4. 内容过滤 (Content Filtering)

#### 实时过滤
- 所有 feed 页面在加载内容时自动过滤被屏蔽用户
- 使用 `filterBlockedUserPosts()` 方法
- 确保被屏蔽用户的内容不会出现在任何地方

#### 实现位置
- `lib/screens/discovery_screen.dart` - 发现页面
- `lib/screens/expert_camping_screen.dart` - 专家露营页面
- 其他显示用户生成内容的页面

## 数据存储

### 本地存储 (SharedPreferences)
- `blocked_users` - 被屏蔽用户ID列表
- `user_reports` - 用户举报记录
- `post_reports` - 帖子举报记录
- `message_reports` - 消息举报记录

### 数据持久化
所有屏蔽和举报数据都会持久化保存，应用重启后仍然有效。

## 测试建议

### 测试屏蔽功能
1. 打开任意用户的资料页面
2. 点击右上角"更多"按钮
3. 选择"屏蔽此用户"
4. 确认屏蔽
5. 验证：
   - 显示成功提示
   - 自动返回上一页
   - 该用户的内容不再出现在 feed 中
   - 控制台输出开发者通知

### 测试举报功能
1. 打开任意用户的资料页面
2. 点击右上角"更多"按钮
3. 选择"举报此用户"
4. 选择举报原因
5. 验证：
   - 显示成功提示
   - 控制台输出开发者通知
   - 举报数据保存到本地

## 合规性检查清单

- [x] 用户可以屏蔽其他用户
- [x] 屏蔽后立即从 feed 中移除内容
- [x] 屏蔽操作通知开发者
- [x] 用户可以举报不当内容
- [x] 举报操作通知开发者
- [x] 提供多种举报原因选项
- [x] 举报数据持久化保存
- [x] 高优先级举报自动标记
- [x] 用户收到举报确认消息

## 后续改进建议

### 短期改进
1. 添加"取消屏蔽"功能
2. 在设置页面显示已屏蔽用户列表
3. 添加举报历史记录查看

### 中期改进
1. 实现后端 API 集成
2. 添加管理员审核仪表板
3. 实现自动内容过滤（AI驱动）

### 长期改进
1. 实现实时内容审核
2. 添加社区管理员角色
3. 实现用户信誉系统
4. 添加内容申诉机制

## 联系方式
如有关于内容审核的问题，请联系开发团队。

---
最后更新：2024年12月
