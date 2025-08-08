import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocationTrackerScreen extends StatefulWidget {
  @override
  _LocationTrackerScreenState createState() => _LocationTrackerScreenState();
}

class _LocationTrackerScreenState extends State<LocationTrackerScreen> {
  final _platform = const MethodChannel('com.example.backgroud_location/service');
  String _lastLocation = 'No location updates yet';
  List<String> _locationHistory = [];

  @override
  void initState() {
    super.initState();
    _setupLocationListener();
  }

  void _setupLocationListener() {
    const channel = MethodChannel('location_updates');

    channel.setMethodCallHandler((call) async {
      if (call.method == 'onLocationUpdate') {
        final lat = call.arguments['latitude'];
        final lng = call.arguments['longitude'];
        final timestamp = DateTime.fromMillisecondsSinceEpoch(
            call.arguments['timestamp']
        ).toString().substring(0, 19);

        setState(() {
          _lastLocation = 'Lat: $lat, Lng: $lng\n$timestamp';
          _locationHistory.insert(0, _lastLocation);
          if (_locationHistory.length > 10) {
            _locationHistory.removeLast();
          }
        });
      }
    });
  }

  Future<void> _startService() async {
    try {
      await _platform.invokeMethod('startLocationService');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location service started')),
      );
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: ${e.message}')),
      );
    }
  }

  Future<void> _stopService() async {
    try {
      await _platform.invokeMethod('stopLocationService');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location service stopped')),
      );
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Background Location Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Last Location', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(_lastLocation),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _locationHistory.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_locationHistory[index]),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
          ],
        ),
      ),
    );
  }
}