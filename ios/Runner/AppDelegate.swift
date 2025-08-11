import Flutter
import UIKit
import CoreLocation

@main
@objc class AppDelegate: FlutterAppDelegate, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let iosLocationChannel = FlutterMethodChannel(name: "location_data", binaryMessenger: controller.binaryMessenger)

        iosLocationChannel.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "getLastLocation" {
                let lat = UserDefaults.standard.double(forKey: "last_lat")
                let lng = UserDefaults.standard.double(forKey: "last_lng")

                if lat != 0 && lng != 0 {
                    result([
                               "latitude": lat,
                               "longitude": lng
                           ])
                } else {
                    result(nil)
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
