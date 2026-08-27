package com.example.connect_share_flutter

import android.content.Context
import android.content.Intent
import android.net.ConnectivityManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.connectshare/hotspot"
    private var tethering = false
    private var tetheringCallback: ConnectivityManager.OnStartTetheringCallback? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startHotspot" -> {
                    val ssid = call.argument<String>("ssid")
                    val password = call.argument<String>("password")
                    startHotspot(ssid, password, result)
                }
                "stopHotspot" -> {
                    stopHotspot(result)
                }
                "isHotspotActive" -> {
                    isHotspotActive(result)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun startHotspot(ssid: String?, password: String?, result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            result.error("HOTSPOT_UNSUPPORTED", "Android 8.0 or newer is required.", null)
            return
        }
        val connectivity = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val callback = object : ConnectivityManager.OnStartTetheringCallback() {
            override fun onTetheringStarted() {
                tethering = true
                result.success(true)
            }

            override fun onTetheringFailed() {
                tethering = false
                openTetheringSettings()
                result.error(
                    "HOTSPOT_PERMISSION_DENIED",
                    "Android rejected Wi-Fi tethering. Enable the system hotspot or grant carrier/system tethering privileges.",
                    null
                )
            }
        }
        tetheringCallback = callback
        try {
            @Suppress("DEPRECATION")
            connectivity.startTethering(
                ConnectivityManager.TETHERING_WIFI,
                false,
                callback,
                Handler(Looper.getMainLooper())
            )
        } catch (e: SecurityException) {
            openTetheringSettings()
            result.error("HOTSPOT_PERMISSION_DENIED", e.message, null)
        } catch (e: Exception) {
            result.error("HOTSPOT_ERROR", e.message, null)
        }
    }

    private fun openTetheringSettings() {
        try {
            startActivity(Intent(Settings.ACTION_TETHER_SETTINGS))
        } catch (_: Exception) {
            startActivity(Intent(Settings.ACTION_WIRELESS_SETTINGS))
        }
    }

    private fun stopHotspot(result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            result.success(false)
            return
        }
        try {
            val connectivity = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
            @Suppress("DEPRECATION")
            connectivity.stopTethering(ConnectivityManager.TETHERING_WIFI)
            tethering = false
            result.success(true)
        } catch (e: SecurityException) {
            result.error("HOTSPOT_PERMISSION_DENIED", e.message, null)
        } catch (e: Exception) {
            result.error("HOTSPOT_ERROR", e.message, null)
        }
    }

    private fun isHotspotActive(result: MethodChannel.Result) {
        result.success(tethering)
    }
}
