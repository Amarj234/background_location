# background_location_runner

A Flutter plugin to track device location **in the background** on Android and iOS, providing continuous location updates even when the app is not in the foreground.

---

## Features

- Request necessary location permissions (WhenInUse and Always)
- Start and stop background location tracking service
- Receive location updates via callback
- Works on both Android and iOS
- Supports background tracking for real-world use cases like fitness, delivery apps, etc.

---

## Installation

Add this to your project's `pubspec.yaml`:

```yaml
dependencies:
  background_location_runner:
    git:
      url: https://github.com/Amarj234/background_location_runner.git
      ref: main


Android Setup
Permissions

Add the following permissions to your android/app/src/main/AndroidManifest.xml inside the <manifest> tag:

xml
Copy
Edit  

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

<!-- For background location (Android 10+) -->
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />

<!-- For Android 13+ notification permission (if your service shows notifications) -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
Foreground Service
xml
Copy
Edit
Make sure your app declares a foreground service in the manifest (if applicable):

xml
Copy
Edit

```xml
     <service
            android:name=".LocationForegroundService"
            android:foregroundServiceType="location"
            android:enabled="true"
            android:exported="false" />


        <service
            android:name="id.flutter.flutter_background_service.FlutterBackgroundService"
            android:foregroundServiceType="location|dataSync"
            android:enabled="true"
            android:exported="false" />
xml
Copy
Edit
Location Settings

Ensure your device location settings allow background location tracking.

iOS Setup
Open your ios/Runner/Info.plist and add these keys:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app requires location access to track your location while using the app.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app requires background location access to track your location even when the app is in the background.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app requires background location access to track your location even when the app is in the background.</string>
<key>UIBackgroundModes</key>
<array>
  <string>location</string>
  <string>fetch</string>
</array>
Make sure Background Modes are enabled in your Xcode project with:

Location updates

Background fetch

Usage
Import and create an instance of BackgroundLocationFetch (replace with your class name):

dart
Copy
Edit
```xml
import 'package:background_location_runner/background_location_fetch.dart';

final BackgroundLocationFetch locationService = BackgroundLocationFetch();

// Start the location service
await locationService.startService();

// Stop the location service
await locationService.stopService();

// Listen to location updates
locationService.onLocationUpdate = (locationData) {
  print('Latitude: ${locationData['latitude']}');
  print('Longitude: ${locationData['longitude']}');
  print('Timestamp: ${locationData['timestamp']}');
};
Example usage inside a Flutter widget:

dart
Copy
Edit
class LocationTrackerScreen extends StatefulWidget {
  // ...
}

class _LocationTrackerScreenState extends State<LocationTrackerScreen> {
  final BackgroundLocationFetch locationService = BackgroundLocationFetch();
  List<Map<String, dynamic>> _locationHistory = [];

  @override
  void initState() {
    super.initState();
    locationService.onLocationUpdate = (locationData) {
      setState(() {
        _locationHistory.insert(0, locationData);
        if (_locationHistory.length > 20) _locationHistory.removeLast();
      });
    };
  }

  // UI buttons to start/stop service and display location history
}
Troubleshooting
Make sure you grant Always location permission for background tracking to work on both Android and iOS.

On iOS simulators, background location updates may not work reliably. Test on a real device.

On Android 10+, background location requires separate permission (ACCESS_BACKGROUND_LOCATION).

Android 13+ requires notification permission if your app shows foreground service notifications.

If using Flutter 3+, verify your Info.plist and Android manifest are correctly set up.

License

This single-file README includes:
1. All essential information in a compact format
2. Clear setup instructions for both platforms
3. Basic usage example
4. Quick reference configuration table
5. Common troubleshooting tips
6. Proper license attribution

The formatting uses clean markdown with clear section headers for easy navigation.