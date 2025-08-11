import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    var locationService: LocationService?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        let serviceChannel = FlutterMethodChannel(
            name: "com.example.backgroud_location/service",
            binaryMessenger: controller.binaryMessenger
        )

        locationService = LocationService(messenger: controller.binaryMessenger)

        serviceChannel.setMethodCallHandler { [weak self] call, result in
            guard let self = self else { return }
            if call.method == "startLocationService" {
                self.locationService?.start()
                result(nil)
            } else if call.method == "stopLocationService" {
                self.locationService?.stop()
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
