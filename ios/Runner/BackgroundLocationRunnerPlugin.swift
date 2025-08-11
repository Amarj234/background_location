import Flutter
import UIKit

public class BackgroundLocationRunnerPlugin: NSObject, FlutterPlugin {
    var locationService: LocationService?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger = registrar.messenger()

        let serviceChannel = FlutterMethodChannel(
            name: "com.example.backgroud_location/service",
            binaryMessenger: messenger
        )

        let instance = BackgroundLocationRunnerPlugin()
        instance.locationService = LocationService(messenger: messenger)

        serviceChannel.setMethodCallHandler { (call, result) in
            if call.method == "startLocationService" {
                instance.locationService?.start()
                result(nil)
            } else if call.method == "stopLocationService" {
                instance.locationService?.stop()
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }
}
