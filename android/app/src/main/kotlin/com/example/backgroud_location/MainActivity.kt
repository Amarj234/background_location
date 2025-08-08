package com.example.backgroud_location

import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.backgroud_location/service"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startLocationService" -> {
                    LocationForegroundService.startService(this)
                    result.success("Service started")
                }
                "stopLocationService" -> {
                    LocationForegroundService.stopService(this)
                    result.success("Service stopped")
                }
                else -> result.notImplemented()
            }
        }
    }
}