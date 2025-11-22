# 应用检测功能实现说明

## 功能概述
在原有的时间戳判断基础上，新增了应用安装检测功能。如果用户的 iOS 设备上**没有安装**以下任意一个应用，将运行 MoodApp (A逻辑):
- 抖音 (Douyin)
- 微信 (WeChat)
- QQ
- 拼多多 (Pinduoduo)
- 快手 (Kuaishou)
- YouTube
- Instagram
- Twitter
- TikTok
- Amazon
- Temu

## 实现逻辑

### 判断条件
```
if (当前时间 < 目标时间戳 || 没有安装任何目标应用) {
    运行 MoodApp (A逻辑)
} else {
    运行 ZhenyuApp (B逻辑)
}
```

## 修改的文件

### 1. ios/Runner/Info.plist
添加了 LSApplicationQueriesSchemes 用于检测应用:
- `snssdk1128` - 抖音
- `weixin` - 微信 (已存在)
- `mqq` - QQ
- `pinduoduo` - 拼多多
- `kwai` / `ksnebula` - 快手
- `youtube` - YouTube
- `instagram` - Instagram
- `twitter` - Twitter
- `tiktok` / `snssdk1233` - TikTok
- `amazon` - Amazon
- `temu` - Temu

### 2. ios/Runner/AppDelegate.swift
- 创建了 MethodChannel: `com.zhenyu.app_checker`
- 实现了 `checkInstalledApps()` 方法
- 返回各个应用的安装状态

### 3. lib/main.dart
- 导入 `package:flutter/services.dart`
- 新增 `hasAnyTargetAppInstalled()` 函数
- 更新 main() 函数的判断逻辑
- 添加详细的调试日志

## 调试日志
运行时会输出以下信息:
```
已安装的应用检测结果:
  抖音: true/false
  微信: true/false
  QQ: true/false
  拼多多: true/false
  快手: true/false
  YouTube: true/false
  Instagram: true/false
  Twitter: true/false
  TikTok: true/false
  Amazon: true/false
  Temu: true/false
  是否有任意一个已安装: true/false
```

## 注意事项
1. 此功能仅在 iOS 平台生效
2. Android 平台默认执行 B 逻辑 (ZhenyuApp)
3. 如果检测失败，默认执行 B 逻辑
4. 需要在 Info.plist 中声明 URL Schemes 才能检测应用
