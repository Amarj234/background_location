import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LocationTrackerScreen(),
    );
  }
}

class LocationTrackerScreen extends StatefulWidget {
  const LocationTrackerScreen({super.key});

  @override
  State<LocationTrackerScreen> createState() => _LocationTrackerScreenState();
}

class _LocationTrackerScreenState extends State<LocationTrackerScreen> {
  final _serviceChannel = const MethodChannel(
    'com.example.backgroud_location/service',
  );
  final _locationChannel = const MethodChannel('location_updates');

  // New channel for iOS direct fetch
  final _iosLocationChannel = const MethodChannel('location_data');

  String _serviceStatus = 'Service not running';
  List<Map<String, dynamic>> _locationHistory = [];

  @override
  void initState() {
    super.initState();
    if (!Platform.isIOS) {
      _setupLocationListener();
    }
  }

  void _setupLocationListener() {
    _locationChannel.setMethodCallHandler((call) async {
      if (call.method == 'onLocationUpdate' && mounted) {
        final latitude = (call.arguments['latitude'] as num).toDouble();
        final longitude = (call.arguments['longitude'] as num).toDouble();
        final timestampMs = call.arguments['timestamp'] as int;
        final locationData = {
          'latitude': latitude,
          'longitude': longitude,
          'timestamp': DateTime.fromMillisecondsSinceEpoch(timestampMs),
        };

        setState(() {
          _locationHistory.insert(0, locationData);
          if (_locationHistory.length > 20) _locationHistory.removeLast();
        });
      }
    });
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

  Future<void> _startService() async {
    final ok = await _requestPermissions();
    if (!ok) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please allow "Always" location permission.'),
          ),
        );
      }
      return;
    }

    try {
      if (Platform.isIOS) {
        // Delay iOS fetch until UI is drawn
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          try {
            final lastLocation = await _iosLocationChannel
                .invokeMethod<Map<dynamic, dynamic>>('getLastLocation');

            if (lastLocation != null && mounted) {
              setState(() {
                _locationHistory.insert(0, {
                  'latitude':
                  (lastLocation['latitude'] as num).toDouble(),
                  'longitude':
                  (lastLocation['longitude'] as num).toDouble(),
                  'timestamp': DateTime.now(),
                });
              });
            }
          } catch (e) {
            debugPrint("iOS location fetch failed: $e");
          }
        });
      } else {
        await _serviceChannel.invokeMethod('startLocationService');
      }

      if (mounted) {
        setState(() {
          _serviceStatus = 'Service running';
        });
      }
    } on PlatformException catch (e) {
      if (mounted) {
        setState(() {
          _serviceStatus = 'Failed to start service';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      }
    }
  }

  Future<void> _stopService() async {
    try {
      if (!Platform.isIOS) {
        await _serviceChannel.invokeMethod('stopLocationService');
      }
      if (mounted) {
        setState(() {
          _serviceStatus = 'Service stopped';
        });
      }
    } on PlatformException catch (e) {
      if (mounted) {
        setState(() {
          _serviceStatus = 'Failed to stop service';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Background Location Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Service Status',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(_serviceStatus),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _startService,
                          child: const Text('Start Service'),
                        ),
                        ElevatedButton(
                          onPressed: _stopService,
                          child: const Text('Stop Service'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Recent Locations',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _locationHistory.length,
                itemBuilder: (context, index) {
                  final loc = _locationHistory[index];
                  final dt = loc['timestamp'] as DateTime;
                  return ListTile(
                    title: Text(
                      'Lat: ${(loc['latitude'] as double).toStringAsFixed(6)}, '
                          'Lng: ${(loc['longitude'] as double).toStringAsFixed(6)}',
                    ),
                    subtitle: Text('Time: $dt'),
                    dense: true,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
