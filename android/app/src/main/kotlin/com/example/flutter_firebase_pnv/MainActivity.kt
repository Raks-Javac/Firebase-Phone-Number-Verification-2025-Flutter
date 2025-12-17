package com.example.flutter_firebase_pnv

import android.os.Bundle
import com.google.firebase.FirebaseApp
import com.google.firebase.pnv.FirebasePhoneNumberVerification
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val channelName = "com.example.flutter_firebase_pnv/pnv"
    private val privacyPolicyUrl = "https://example.com/privacy-policy"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        FirebaseApp.initializeApp(this)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getVerifiedPhoneNumber" -> handleGetVerifiedPhoneNumber(result)
                    else -> result.notImplemented()
                }
            }
    }

    private fun handleGetVerifiedPhoneNumber(result: MethodChannel.Result) {
        val fpnv = FirebasePhoneNumberVerification.getInstance(this@MainActivity)

        fpnv.verificationSupportInfo
            .addOnSuccessListener { support ->
                val anySupported = support.any { it.isSupported() }
                if (!anySupported) {
                    result.error(
                        "UNSUPPORTED",
                        "No SIMs support Firebase Phone Number Verification",
                        null
                    )
                    return@addOnSuccessListener
                }

                fpnv.getVerifiedPhoneNumber(privacyPolicyUrl)
                    .addOnSuccessListener { verificationResult ->
                        val phone = verificationResult.phoneNumber
                        val token = verificationResult.token
                        result.success(
                            mapOf(
                                "phoneNumber" to phone,
                                "token" to token,
                            )
                        )
                    }
                    .addOnFailureListener { e ->
                        result.error("PNV_ERROR", e.message, null)
                    }
            }
            .addOnFailureListener { e ->
                result.error("PNV_SUPPORT_ERROR", e.message, null)
            }
    }
}
