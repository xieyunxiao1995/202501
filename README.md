# zhenyu_flutter

## 检查 flutter

- flutter doctor 命令来检查你的环境。这个命令会帮助我们诊断 Flutter 开发环境的所有组件，并告诉我们是否还有需要安装或配置的部分
- flutter devices 可用的设备是什么
- flutter emulators 查看所有可用的模拟器。
- flutter emulators --launch apple_ios_simulator 运行通过 flutter emulators 查看的模拟器
- flutter run 运行

- flutter clean 可以清理 Flutter 编译缓存
- flutter pub get

## 突然构建失败了

- flutter clean && flutter pub get
- cd ios && pod install

## 发布 testflight 版本

- 更新 pubspec.yaml 文件中的的 version （+1 就好）
- 运行以下命令
  - flutter build ipa --release
- 上传到 macbook 的 app -> transport app
- 查看 appstoreconnect 网站 中的 app-具体 app-testflight 中是否完成
- 记得给每个单独的版本提供
  - 缺少出口合规证明 选择： 代替在 Apple 操作系统中使用或访问加密，或与这些操作同时使用的标准加密算法。

## 生成图标

- 换一个的 1024\*1024 照片
  改到 assets/images/app_icon.png
- flutter pub run flutter_launcher_icons
- 执行后命令行会提示为 Android、iOS 替换了哪些图标。

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
