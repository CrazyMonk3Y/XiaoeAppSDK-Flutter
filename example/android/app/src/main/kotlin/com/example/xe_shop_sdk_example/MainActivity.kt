package com.example.xe_shop_sdk_example

import android.os.Bundle
import android.webkit.CookieManager
import android.webkit.CookieSyncManager
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)
    }
}
