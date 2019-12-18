package com.example.xe_shop_sdk_example

import android.os.Bundle
import android.webkit.CookieManager
import android.webkit.CookieSyncManager
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity : FlutterActivity() {
    var htmlUrl = "https://app38itOR341547.sdk.xiaoe-tech.com/"
    var clientId = "883pzzGyzynE72G"
    var appId = "app38itOR341547"
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)
        CookieSyncManager.createInstance(this)
        val cookieManager = CookieManager.getInstance()
        cookieManager.setAcceptCookie(true)
        cookieManager.removeSessionCookie()
        cookieManager.removeAllCookie()
        cookieManager.setCookie(htmlUrl, "app_id=$appId")
        cookieManager.setCookie(htmlUrl, "sdk_app_id=$clientId")
        cookieManager.setCookie(htmlUrl, "xe_sdk_token=0440abb1879a1bb7b480b9daebdbad0f")
        CookieSyncManager.getInstance().sync()
    }
}
