package com.example.background_location_runner

import android.content.Intent
import android.os.Build
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel


class BackgroundLocationRunnerPlugin : FlutterPlugin {
    private var serviceChannel: MethodChannel? = null
    private var locationChannel: MethodChannel? = null
    private lateinit var context: android.content.Context

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext

        serviceChannel = MethodChannel(binding.binaryMessenger, "com.example.backgroud_location/service")
        locationChannel = MethodChannel(binding.binaryMessenger, "location_updates")

        serviceChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "startLocationService" -> {
                    startLocationService()
                    result.success(null)
                }
                "stopLocationService" -> {
                    stopLocationService()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun startLocationService() {
        val intent = Intent(context, LocationForegroundService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            ContextCompat.startForegroundService(context, intent)
        } else {
            context.startService(intent)
        }
    }

    private fun stopLocationService() {
        val intent = Intent(context, LocationForegroundService::class.java)
        context.stopService(intent)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        serviceChannel?.setMethodCallHandler(null)
        locationChannel?.setMethodCallHandler(null)
    }
}
