package com.example.backgroud_location

import android.content.Intent
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        lateinit var channel: MethodChannel
        private const val CHANNEL = "com.example.location_channel"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceIntent = Intent(this, LocationForegroundService::class.java)
            startForegroundService(serviceIntent)
        } else {
            val serviceIntent = Intent(this, LocationForegroundService::class.java)
            startService(serviceIntent)
        }
    }
}
