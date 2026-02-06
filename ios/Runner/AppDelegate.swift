import Flutter
import UIKit
import AppTrackingTransparency

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
//      NSException(name:NSExceptionName(rawValue: "Crash"), reason:"Crash.", userInfo:nil).raise()
      // 唯一且优化的ATT请求（延迟3.5秒）
         DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
             if #available(iOS 14, *) {
                 ATTrackingManager.requestTrackingAuthorization { status in
                     // 处理授权结果
                 }
             }
         }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
