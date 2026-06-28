# CPDD小屋

每天打开衣柜，我们面对的不只是衣服，而是今天想成为怎样的自己。

CPDD小屋 是一款穿搭记录与衣橱管理应用。它帮助你留住值得被记住的穿搭瞬间，也陪你理性地对待每一次消费决策。所有数据保存在本地，只属于你自己。

## 已实现功能

- 双列穿搭日记：相册添加、日期、场合、心情、衣物关联、详情、编辑和删除。
- 双列个人衣橱：分类筛选、相册添加、颜色、季节、愿望清单、养护备注、详情、编辑和删除。
- AI 穿搭助手：自动拼接衣橱及近期穿搭上下文，支持穿搭、理性购物和衣物养护快捷问题。
- 设置：数据统计、清空本地数据、关于我们、用户协议、隐私协议、使用帮助、反馈与建议。
- 启动体验：每次冷启动展示四屏画册式功能轮播；支持跳过。
- EULA 登录：无需账号密码，用户主动阅读并同意最终用户许可协议后进入 App。
- 本地存储：结构化数据使用 `shared_preferences`，相册图片复制到应用文档目录。

## DeepSeek 配置

在 `lib/config/deepseek_config.dart` 中替换：

```dart
static const apiKey = 'REPLACE_WITH_YOUR_DEEPSEEK_API_KEY';
```

客户端内置密钥只能用于内部测试。正式上架前应改用服务端代理，避免密钥从安装包中被提取。

## 运行与验证

```bash
flutter pub get
flutter analyze
flutter test
flutter build ios --simulator
```

如果当前网络无法连接 `pub.dev`，可以仅在当前命令中临时使用 Flutter 中国镜像：

```bash
PUB_HOSTED_URL=https://pub.flutter-io.cn \
FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn \
flutter pub get
```

完整产品与技术设计见：

- `docs/plans/2026-06-21-cpcloth-design.md`
- `docs/plans/2026-06-21-onboarding-eula-design.md`
