import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // 注册 MethodChannel 用于检测已安装的应用
    let controller = window?.rootViewController as! FlutterViewController
    let appCheckChannel = FlutterMethodChannel(
      name: "com.zhenyu.app_checker",
      binaryMessenger: controller.binaryMessenger
    )
    
    appCheckChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "checkInstalledApps" {
        let installedApps = self.checkInstalledApps()
        result(installedApps)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func checkInstalledApps() -> [String: Bool] {
    let appsToCheck = [
      "douyin": "snssdk1128://",      // 抖音
      "wechat": "weixin://",          // 微信
      "qq": "mqq://",                 // QQ
      "pinduoduo": "pinduoduo://",    // 拼多多
      "kuaishou": "kwai://",          // 快手
      "youtube": "youtube://",        // YouTube
      "instagram": "instagram://",    // Instagram
      "twitter": "twitter://",        // Twitter
      "tiktok": "tiktok://",          // TikTok
      "amazon": "amazon://",          // Amazon
      "temu": "temu://"               // Temu
    ]
    
    var result: [String: Bool] = [:]
    
    for (appName, urlScheme) in appsToCheck {
      if let url = URL(string: urlScheme) {
        result[appName] = UIApplication.shared.canOpenURL(url)
      } else {
        result[appName] = false
      }
    }
    
    return result
  }
}
