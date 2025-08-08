import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const MethodChannel _channel = MethodChannel('com.example.location_channel');

  String _location = "Waiting for location...";

  @override
  void initState() {
    super.initState();
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    if (call.method == "locationUpdate") {
      final double lat = call.arguments['latitude'];
      final double lng = call.arguments['longitude'];
      setState(() {
        _location = "Lat: $lat, Lng: $lng";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Location Tracker')),
        body: Center(child: Text(_location, style: const TextStyle(fontSize: 20))),
      ),
    );
  }
}
