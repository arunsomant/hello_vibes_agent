package com.mingletalk.agent

import android.app.KeyguardManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.os.PowerManager
import android.util.Log
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
        private const val TAG = "MainActivity"
    }

    private val SETTINGS_CHANNEL = "com.mingletalk.agent/settings"
    private val DEVICE_INFO_CHANNEL = "com.mingletalk.agent/device_info"
    private val LOCK_SCREEN_CHANNEL = "com.mingletalk.agent/lock_screen"

    // Track if we should show over lock screen (only for calling screens)
    private var showOverLockScreenEnabled = false

    // Track if we launched from a call (to auto-enable lock screen display)
    private var launchedFromCall = false

    override fun onCreate(savedInstanceState: Bundle?) {
        // Check if launched from CallKit before super.onCreate()
        launchedFromCall = isDeviceLockedCheck() || isLaunchedFromCallKit(intent)

        Log.d(TAG, "onCreate: launchedFromCall=$launchedFromCall, deviceLocked=${isDeviceLockedCheck()}")

        if (launchedFromCall) {
            Log.d(TAG, "Enabling lock screen flags at startup for incoming call")
            showOverLockScreenEnabled = true
            applyLockScreenFlags(true)
        }

        super.onCreate(savedInstanceState)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)

        if (isDeviceLockedCheck() || isLaunchedFromCallKit(intent)) {
            Log.d(TAG, "New intent - enabling lock screen for call")
            showOverLockScreenEnabled = true
            applyLockScreenFlags(true)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Settings channel for OEM autostart
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SETTINGS_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "openAutoStart" -> {
                        val intentStr = call.argument<String>("intent")
                        if (intentStr != null) {
                            result.success(openAutoStartSettings(intentStr))
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
                    "getManufacturer" -> result.success(Build.MANUFACTURER)
                    "getModel" -> result.success(Build.MODEL)
                    "getBrand" -> result.success(Build.BRAND)
                    else -> result.notImplemented()
                }
            }

        // Lock screen channel - control showing over lock screen for CallingPage ONLY
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, LOCK_SCREEN_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "enableShowOnLockScreen" -> {
                        Log.d(TAG, "Flutter requested: enableShowOnLockScreen")
                        showOverLockScreenEnabled = true
                        applyLockScreenFlags(true)
                        result.success(true)
                    }
                    "disableShowOnLockScreen" -> {
                        Log.d(TAG, "Flutter requested: disableShowOnLockScreen")
                        showOverLockScreenEnabled = false
                        applyLockScreenFlags(false)
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    /**
     * Apply or remove lock screen flags
     */
    private fun applyLockScreenFlags(enable: Boolean) {
        runOnUiThread {
            if (enable) {
                Log.d(TAG, "Applying lock screen flags - ENABLE")

                // Turn on screen if it's off
                wakeUpScreen()

                // API 27+ method
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
                    setShowWhenLocked(true)
                    setTurnScreenOn(true)
                }

                // Window flags (works on all versions)
                @Suppress("DEPRECATION")
                window.addFlags(
                    WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                    WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                    WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or
                    WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD
                )

                // Request keyguard dismissal
                dismissKeyguard()

            } else {
                Log.d(TAG, "Applying lock screen flags - DISABLE")

                // API 27+ method
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
                    setShowWhenLocked(false)
                    setTurnScreenOn(false)
                }

                // Clear window flags
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

    private fun wakeUpScreen() {
        try {
            val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
            if (!powerManager.isInteractive) {
                @Suppress("DEPRECATION")
                val wakeLock = powerManager.newWakeLock(
                    PowerManager.FULL_WAKE_LOCK or
                    PowerManager.ACQUIRE_CAUSES_WAKEUP or
                    PowerManager.ON_AFTER_RELEASE,
                    "MingleTalk:CallWakeLock"
                )
                wakeLock.acquire(3000L) // Hold for 3 seconds
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error waking up screen: ${e.message}")
        }
    }

    private fun dismissKeyguard() {
        try {
            val keyguardManager = getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                keyguardManager.requestDismissKeyguard(this, object : KeyguardManager.KeyguardDismissCallback() {
                    override fun onDismissSucceeded() {
                        Log.d(TAG, "Keyguard dismissed successfully")
                    }
                    override fun onDismissCancelled() {
                        Log.d(TAG, "Keyguard dismiss cancelled")
                    }
                    override fun onDismissError() {
                        Log.d(TAG, "Keyguard dismiss error")
                    }
                })
            } else {
                @Suppress("DEPRECATION")
                val keyguardLock = keyguardManager.newKeyguardLock("MingleTalkCall")
                @Suppress("DEPRECATION")
                keyguardLock.disableKeyguard()
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error dismissing keyguard: ${e.message}")
        }
    }

    private fun isDeviceLockedCheck(): Boolean {
        return try {
            val keyguardManager = getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
            keyguardManager.isKeyguardLocked
        } catch (e: Exception) {
            false
        }
    }

    private fun isLaunchedFromCallKit(intent: Intent?): Boolean {
        if (intent == null) return false
        
        val extras = intent.extras
        if (extras != null) {
            val callKitKeys = listOf(
                "id", "uuid", "callUUID", "flutter_callkit_incoming",
                "nameCaller", "handle", "type", "extra",
                "EXTRA_CALLKIT_ID", "EXTRA_CALLKIT_HANDLE", "EXTRA_CALLKIT_NAME"
            )
            for (key in callKitKeys) {
                if (extras.containsKey(key)) {
                    Log.d(TAG, "Found CallKit key: $key")
                    return true
                }
            }
        }

        val action = intent.action
        if (action != null && (
            action.contains("callkit", ignoreCase = true) ||
            action.contains("ACCEPT", ignoreCase = true) ||
            action.contains("ANSWER", ignoreCase = true) ||
            action.contains("com.hiennv.flutter_callkit_incoming", ignoreCase = true)
        )) {
            return true
        }

        return false
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

