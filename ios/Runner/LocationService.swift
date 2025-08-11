import Foundation
import CoreLocation
import Flutter

class LocationService: NSObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager!
    private var locationChannel: FlutterMethodChannel

    init(messenger: FlutterBinaryMessenger) {
        locationChannel = FlutterMethodChannel(name: "location_updates", binaryMessenger: messenger)
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }

    func start() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    func stop() {
        locationManager.stopUpdatingLocation()
    }

    // MARK: - CLLocationManagerDelegate
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        let data: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            "timestamp": Int(location.timestamp.timeIntervalSince1970 * 1000)
        ]

        locationChannel.invokeMethod("onLocationUpdate", arguments: data)
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
    }
}
