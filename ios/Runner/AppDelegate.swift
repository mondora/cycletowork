import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let apiKey = ProcessInfo.processInfo.environment["MAPS_API_KEY"]
    GMSServices.provideAPIKey("AIzaSyD9P0StlYqOvvIyt5LK0TM_rtDsgM9fLEE")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
