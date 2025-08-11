import 'package:flutter/services.dart';

class IOSLocationHelper {
  static const MethodChannel _channel = MethodChannel('location_data');

  static Future<Map<String, double>?> getLastLocation() async {
    final result = await _channel.invokeMethod<Map>('getLastLocation');
    if (result == null) return null;
    return {
      "latitude": result["latitude"] as double,
      "longitude": result["longitude"] as double,
    };
  }
}
