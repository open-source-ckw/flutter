package com.stacks

import android.content.Intent
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.PluginRegistry;
import java.util.*


class MainActivity: FlutterActivity() {

    private var sharedText: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val intent = intent
        val action: String? = intent.action
        val type: String? = intent.type
        if (Intent.ACTION_SEND == action && type != null) {
            if ("text/plain" == type) {
                handleSendText(intent) // Handle text being sent
            }
        }
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, "app.channel.shared.data").setMethodCallHandler { call, result ->
            if (call.method!!.contentEquals("getSharedText")) {
                result.success(sharedText)
                sharedText = null
            }
        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }


    fun handleSendText(intent: Intent) {
        sharedText = intent.getStringExtra(Intent.EXTRA_TEXT)
    }
}
