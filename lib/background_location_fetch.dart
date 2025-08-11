
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

typedef LocationUpdateCallback = void Function(Map<String, dynamic> locationData);

class BackgroundLocationFetch {
  static const MethodChannel _locationChannel = MethodChannel('location_updates');
  final _serviceChannel = const MethodChannel('com.example.backgroud_location/service');

  LocationUpdateCallback? onLocationUpdate;

  BackgroundLocationFetch() {
    _locationChannel.setMethodCallHandler(_handleMethodCall);
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    if (call.method == 'onLocationUpdate') {
      final latitude = (call.arguments['latitude'] as num).toDouble();
      final longitude = (call.arguments['longitude'] as num).toDouble();
      final timestampMs = call.arguments['timestamp'] as int;

      final locationData = {
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': DateTime.fromMillisecondsSinceEpoch(timestampMs),
      };

      if (onLocationUpdate != null) {
        onLocationUpdate!(locationData);
      }
    }
    return null;
  }



  Future<bool> _requestPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    var whenInUse = await Permission.locationWhenInUse.request();
    if (!whenInUse.isGranted) return false;

    var always = await Permission.locationAlways.request();
    return always.isGranted;
  }

  Future<void> startService() async {
    final ok = await _requestPermissions();
    if (!ok) {

      return;
    }

    try {
      await _serviceChannel.invokeMethod('startLocationService');
     print('Service running');


    } on PlatformException catch (e) {

      print('Error: ${e.message}');
    }
  }

  Future<void> stopService() async {
    try {
      await _serviceChannel.invokeMethod('stopLocationService');
      print('Service Stopped');

    } on PlatformException catch (e) {

      print('Error: ${e.message}');  }
  }

}
