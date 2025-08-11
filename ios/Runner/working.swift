// import Flutter
// import UIKit
// import CoreLocation
//
// @UIApplicationMain
// class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
//     var locationManager: CLLocationManager?
//
//     func application(_ application: UIApplication,
//                      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//         locationManager = CLLocationManager()
//         locationManager?.delegate = self
//         locationManager?.requestAlwaysAuthorization()
//         locationManager?.allowsBackgroundLocationUpdates = true
//         locationManager?.pausesLocationUpdatesAutomatically = false
//         locationManager?.startUpdatingLocation()
//         return true
//     }
//
//     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//         if let location = locations.last {
//             print("Lat: \(location.coordinate.latitude), Lng: \(location.coordinate.longitude)")
//             // Save to UserDefaults so Flutter can read it later
//             UserDefaults.standard.set(location.coordinate.latitude, forKey: "last_lat")
//             UserDefaults.standard.set(location.coordinate.longitude, forKey: "last_lng")
//         }
//     }
// }
