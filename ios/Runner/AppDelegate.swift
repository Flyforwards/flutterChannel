import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
   
      let controller = window?.rootViewController as! FlutterViewController;
      
      let binaryMessenger = controller.binaryMessenger;
      
      Channel.shareInstance.initMethodChannel(binaryMessager: binaryMessenger)
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
