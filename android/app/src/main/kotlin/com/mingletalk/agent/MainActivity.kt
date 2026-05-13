package com.mingletalk.agent

import android.content.ComponentName
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val SETTINGS_CHANNEL = "com.mingletalk.agent/settings"
    private val DEVICE_INFO_CHANNEL = "com.mingletalk.agent/device_info"
    private val LOCK_SCREEN_CHANNEL = "com.mingletalk.agent/lock_screen"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Settings channel for OEM autostart
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SETTINGS_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "openAutoStart" -> {
                        val intentStr = call.argument<String>("intent")
                        if (intentStr != null) {
                            val opened = openAutoStartSettings(intentStr)
                            result.success(opened)
                        } else {
                            result.error("INVALID_ARGUMENT", "Intent is required", null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }

        // Device info channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DEVICE_INFO_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getManufacturer" -> {
                        result.success(Build.MANUFACTURER)
                    }
                    "getModel" -> {
                        result.success(Build.MODEL)
                    }
                    "getBrand" -> {
                        result.success(Build.BRAND)
                    }
                    else -> result.notImplemented()
                }
            }

        // Lock screen channel - enable/disable showing over lock screen dynamically
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, LOCK_SCREEN_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "enableShowOnLockScreen" -> {
                        enableLockScreenFlags()
                        result.success(true)
                    }
                    "disableShowOnLockScreen" -> {
                        disableLockScreenFlags()
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun enableLockScreenFlags() {
        runOnUiThread {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
                setShowWhenLocked(true)
                setTurnScreenOn(true)
            } else {
                @Suppress("DEPRECATION")
                window.addFlags(
                    WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                            WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                            WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or
                            WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD
                )
            }
        }
    }

    private fun disableLockScreenFlags() {
        runOnUiThread {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
                setShowWhenLocked(false)
                setTurnScreenOn(false)
            } else {
                @Suppress("DEPRECATION")
                window.clearFlags(
                    WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                            WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                            WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or
                            WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD
                )
            }
        }
    }

    private fun openAutoStartSettings(intentStr: String): Boolean {
        return try {
            val parts = intentStr.split("/")
            if (parts.size == 2) {
                val intent = Intent().apply {
                    component = ComponentName(parts[0], parts[1])
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                }
                startActivity(intent)
                true
            } else {
                false
            }
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }
}

