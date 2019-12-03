package com.example.xe_shop_sdk

import com.xiaoe.shop.webcore.XEToken
import com.xiaoe.shop.webcore.XiaoEWeb
import com.xiaoe.shop.webcore.webview.XeWebLayout
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class XeShopSdkPlugin(val registrar: Registrar) : MethodCallHandler {

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            //plugin channel
            val channel = MethodChannel(registrar.messenger(), "xe_shop_sdk")
            val xeShopSdkPlugin = XeShopSdkPlugin(registrar)
            channel.setMethodCallHandler(xeShopSdkPlugin)
        }
    }

    var xeWebView: XeWebLayout? = null
    override fun onMethodCall(methodCall: MethodCall, result: Result) {
        when (methodCall.method) {
            "initConfig" -> {
                val clientId = methodCall.argument<String>("clientId")
                val appId = methodCall.argument<String>("appId")
                XiaoEWeb.init(registrar.activity() ,appId, clientId, XiaoEWeb.WebViewType.Android)
                XeWebViewFlutterPlugin.registerWith(registrar.activity() as FlutterActivity) { wv, messenger, id, params ->
                    xeWebView = wv
                }
            }
            "synchronizeToken" -> {
                val tokenKey = methodCall.argument<String>("token_key")
                val tokenValue = methodCall.argument<String>("token_value")
                xeWebView?.sync(XEToken(tokenKey, tokenValue))
            }
            "logoutSDK" -> {
                XiaoEWeb.userLogout(registrar.context())
            }
            "isLog" -> {
                val clientId = methodCall.argument<Boolean>("isLog")
                clientId?.let { XiaoEWeb.isOpenLog(it) }
            }
            "getSdkVersion" -> {
                XiaoEWeb.getSdkVersion()
            }
        }
    }
}
