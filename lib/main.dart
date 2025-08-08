import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LocationServiceController(),
    );
  }
}

class LocationServiceController extends StatefulWidget {
  @override
  _LocationServiceControllerState createState() => _LocationServiceControllerState();
}

class _LocationServiceControllerState extends State<LocationServiceController> {
  static const platform = MethodChannel('com.example.backgroud_location/service');
  String _serviceStatus = 'Service not running';

  Future<void> _startService() async {
    try {
      final String result = await platform.invokeMethod('startLocationService');
      setState(() {
        _serviceStatus = result;
      });
    } on PlatformException catch (e) {
      setState(() {
        _serviceStatus = "Failed to start: '${e.message}'.";
      });
    }
  }

  Future<void> _stopService() async {
    try {
      final String result = await platform.invokeMethod('stopLocationService');
      setState(() {
        _serviceStatus = result;
      });
    } on PlatformException catch (e) {
      setState(() {
        _serviceStatus = "Failed to stop: '${e.message}'.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Background Location Service')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_serviceStatus),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startService,
              child: Text('Start Service'),
            ),
            ElevatedButton(
              onPressed: _stopService,
              child: Text('Stop Service'),
            ),
          ],
        ),
      ),
    );
  }
}