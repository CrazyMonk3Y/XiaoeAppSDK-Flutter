package com.example.xe_shop_sdk

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Handler
import android.os.Message
import com.xiaoe.shop.webcore.XiaoEWeb
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.util.HashMap

class XeShopSdkPlugin(val registrar: Registrar) : MethodCallHandler {
    
    var title: String = ""
    var titleColor: String = ""
    var backgroundColor: String = ""
    var tokenKey: String = ""
    var tokenValue: String = ""

    companion object {
        var handler: Handler? = null
        
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "xe_shop_sdk")
            val xeShopSdkPlugin = XeShopSdkPlugin(registrar)
            channel.setMethodCallHandler(xeShopSdkPlugin)
            
            handler = @SuppressLint("HandlerLeak")
            object: Handler(){
                override fun handleMessage(msg: Message) {
                    super.handleMessage(msg)
                    when(msg.what) {
                        0x110 ->{
                            val param = HashMap<String, Any>()
                            param["code"] = 501
                            param["message"] = "登录通知"
                            channel.invokeMethod("android", param)
                        }
                        0x111 ->{
                            val param = HashMap<String, Any>()
                            param["code"] = 503
                            param["message"] = "分享通知"
                            param["data"] = msg.obj
                            channel.invokeMethod("android", param)
                        }
                    }
                }
            }
        }
    }

    override fun onMethodCall(methodCall: MethodCall, result: Result) {
        when (methodCall.method) {
            "initConfig" -> {
                val clientId = methodCall.argument<String>("clientId")
                val appId = methodCall.argument<String>("appId")
                XiaoEWeb.init(registrar.activity() ,appId, clientId, XiaoEWeb.WebViewType.X5)
                XiaoEWeb.isOpenLog(true)
            }
            "setNavStyle" -> {
                title = methodCall.argument<String>("title").toString()
                titleColor = methodCall.argument<String>("titleColor").toString()
                backgroundColor = methodCall.argument<String>("backgroundColor").toString()
            }
            "open" -> {
                val shopUrl = methodCall.argument<String>("url")
                val webIntent = Intent(registrar.context(), XEActivity::class.java)
                webIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                webIntent.putExtra("shop_url", shopUrl)
                webIntent.putExtra("title", title)
                webIntent.putExtra("titleColor", titleColor)
                webIntent.putExtra("backgroundColor", backgroundColor)
                webIntent.putExtra("tokenKey", tokenKey)
                webIntent.putExtra("tokenValue", tokenValue)
                registrar.context().startActivity(webIntent)
            }
            "synchronizeToken" -> {
                tokenKey = methodCall.argument<String>("token_key").toString()
                tokenValue = methodCall.argument<String>("token_value").toString()
                val intent = Intent("XE_SDK_SYS_TOKEN")
                intent.putExtra("tokenKey", tokenKey)
                intent.putExtra("tokenValue", tokenValue)
                registrar.context().sendBroadcast(intent)
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
