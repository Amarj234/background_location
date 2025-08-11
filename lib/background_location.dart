import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'background_location_fetch.dart';
// import the new class here

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const LocationTrackerScreen());
  }
}

class LocationTrackerScreen extends StatefulWidget {
  const LocationTrackerScreen({super.key});

  @override
  State<LocationTrackerScreen> createState() => _LocationTrackerScreenState();
}

class _LocationTrackerScreenState extends State<LocationTrackerScreen> {
   final BackgroundLocationFetch locationService = BackgroundLocationFetch();

  String _serviceStatus = 'Service not running';
  List<Map<String, dynamic>> _locationHistory = [];

  @override
  void initState() {
    super.initState();

    // Setup listener callback
    locationService.onLocationUpdate = (locationData) {
      if (!mounted) return;
      setState(() {
        _locationHistory.insert(0, locationData);
        if (_locationHistory.length > 20) _locationHistory.removeLast();
      });
    };
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
                    const Text('Service Status', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(_serviceStatus),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(onPressed: locationService.startService, child: const Text('Start Service')),
                        ElevatedButton(onPressed:locationService.stopService, child: const Text('Stop Service')),
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
                  final dt = loc['timestamp'] as DateTime;
                  return ListTile(
                    title: Text(
                      'Lat: ${(loc['latitude'] as double).toStringAsFixed(6)}, Lng: ${(loc['longitude'] as double).toStringAsFixed(6)}',
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
