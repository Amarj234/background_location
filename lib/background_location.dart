import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocationTrackerScreen extends StatefulWidget {
  const LocationTrackerScreen({super.key});

  @override
  State<LocationTrackerScreen> createState() => _LocationTrackerScreenState();
}

class _LocationTrackerScreenState extends State<LocationTrackerScreen> {
  final _serviceChannel = const MethodChannel('com.example.backgroud_location/service');
  final _locationChannel = const MethodChannel('location_updates');

  String _serviceStatus = 'Service not running';
  List<Map<String, dynamic>> _locationHistory = [];

  @override
  void initState() {
    super.initState();
    _setupLocationListener();
  }

  void _setupLocationListener() {
    _locationChannel.setMethodCallHandler((call) async {
      if (call.method == 'onLocationUpdate' && mounted) {
        final locationData = {
          'latitude': call.arguments['latitude'],
          'longitude': call.arguments['longitude'],
          'timestamp': DateTime.fromMillisecondsSinceEpoch(call.arguments['timestamp']),
        };

        setState(() {
          _locationHistory.insert(0, locationData);
          if (_locationHistory.length > 20) {
            _locationHistory.removeLast();
          }
        });
      }
    });
  }

  Future<void> _startService() async {
    try {
      await _serviceChannel.invokeMethod('startLocationService');
      setState(() {
        _serviceStatus = 'Service running';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location service started')),
      );
    } on PlatformException catch (e) {
      setState(() {
        _serviceStatus = 'Failed to start service';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    }
  }

  Future<void> _stopService() async {
    try {
      await _serviceChannel.invokeMethod('stopLocationService');
      setState(() {
        _serviceStatus = 'Service stopped';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location service stopped')),
      );
    } on PlatformException catch (e) {
      setState(() {
        _serviceStatus = 'Failed to stop service';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Background Location Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Service Status', style: TextStyle(fontWeight: FontWeight.bold)),
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
            const Text('Recent Locations', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _locationHistory.length,
                itemBuilder: (context, index) {
                  final loc = _locationHistory[index];
                  return ListTile(
                    title: Text('Lat: ${loc['latitude']?.toStringAsFixed(6)}, Lng: ${loc['longitude']?.toStringAsFixed(6)}'),
                    subtitle: Text('Time: ${loc['timestamp']}'),
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