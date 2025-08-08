//package com.example.backgroud_location
//
//import android.Manifest
//import android.app.*
//import android.content.Intent
//import android.content.pm.ServiceInfo
//import android.location.Location
//import android.os.Build
//import android.os.IBinder
//import android.util.Log
//import androidx.core.app.NotificationCompat
//import com.google.android.gms.location.*
//import io.flutter.plugin.common.MethodChannel
//
//class LocationForegroundService : Service() {
//    private lateinit var fusedLocationClient: FusedLocationProviderClient
//    private lateinit var locationCallback: LocationCallback
//    lateinit var methodChannel: MethodChannel
//    override fun onCreate() {
//        super.onCreate()
//        startForegroundService()
//        startLocationUpdates()
//    }
//
//    private fun startForegroundService() {
//        val channelId = "location_channel"
//        val channelName = "Location Tracking"
//        val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
//
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            val channel = NotificationChannel(channelId, channelName, NotificationManager.IMPORTANCE_LOW)
//            notificationManager.createNotificationChannel(channel)
//        }
//
//        val notification = NotificationCompat.Builder(this, channelId)
//            .setContentTitle("Tracking Location")
//            .setContentText("Running in background")
//            .setSmallIcon(R.mipmap.ic_launcher)
//            .build()
//
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
//            startForeground(1, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION)
//        } else {
//            startForeground(1, notification)
//        }
//    }
//
//    private fun startLocationUpdates() {
//        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
//
//        val locationRequest = LocationRequest.create().apply {
//            interval = 5000
//            fastestInterval = 3000
//            priority = LocationRequest.PRIORITY_HIGH_ACCURACY
//        }
//
//        locationCallback = object : LocationCallback() {
//            override fun onLocationResult(result: LocationResult) {
//                super.onLocationResult(result)
//                val location: Location? = result.lastLocation
//                location?.let {
//                    Log.d("LocationService", "Lat: ${it.latitude}, Lng: ${it.longitude}")
//                    sendLocationToFlutter(location.latitude, location.longitude)
//                }
//            }
//        }
//
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
//            fusedLocationClient.requestLocationUpdates(
//                locationRequest,
//                locationCallback,
//                mainLooper
//            )
//        }
//    }
//
//    override fun onBind(intent: Intent?): IBinder? = null
//
//    override fun onDestroy() {
//        super.onDestroy()
//        fusedLocationClient.removeLocationUpdates(locationCallback)
//    }
//    fun sendLocationToFlutter(latitude: Double, longitude: Double) {
//        val args = mapOf("latitude" to latitude, "longitude" to longitude)
//
//        methodChannel.invokeMethod("locationUpdate", args)
//    }
//}
