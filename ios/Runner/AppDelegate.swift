import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // NSException(name:NSExceptionName(rawValue: "Crash"), reason:"Crash.", userInfo:nil).raise()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
