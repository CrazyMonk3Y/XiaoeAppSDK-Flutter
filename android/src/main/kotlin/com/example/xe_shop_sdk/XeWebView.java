package com.example.xe_shop_sdk;

import android.app.Activity;
import android.content.Context;
import androidx.annotation.NonNull;
import android.view.View;
import com.xiaoe.shop.webcore.XEToken;
import com.xiaoe.shop.webcore.bridge.JsBridgeListener;
import com.xiaoe.shop.webcore.bridge.JsCallbackResponse;
import com.xiaoe.shop.webcore.bridge.JsInteractType;
import com.xiaoe.shop.webcore.webview.XeWebLayout;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class XeWebView implements PlatformView, MethodChannel.MethodCallHandler {

    private final XeWebLayout myNativeView;
    private final String SHOP_URL;
    private final MethodChannel mChannel;

    XeWebView(Context context, final BinaryMessenger messenger, int viewId, Map<String, Object> params, IXeWebView webView) {
        Context activityContext = context;
        Context appContext = context.getApplicationContext();
        if (appContext instanceof FlutterApplication) {
            Activity currentActivity = ((FlutterApplication) appContext).getCurrentActivity();
            if (currentActivity != null) {
                activityContext = currentActivity;
            }
        }

        SHOP_URL = Objects.requireNonNull(params.get("url")).toString();
        XeWebLayout myNativeView = new XeWebLayout(activityContext);
        webView.getWebView(myNativeView, messenger, viewId, params);
        mChannel = new MethodChannel(messenger, "com.xiaoe-tech.xewebview_" + viewId + "");
        mChannel.setMethodCallHandler(this);
        this.myNativeView = myNativeView;
    }

    @Override
    public View getView() {
        return myNativeView;
    }

    @Override
    public void dispose() {
    }

    @Override
    public void onMethodCall(@NonNull MethodCall methodCall, @NonNull MethodChannel.Result result) {
        final String method = methodCall.method;
        if ("load".equals(method)) {
            myNativeView.loadUrl(SHOP_URL);
            myNativeView.setJsCallBack(new JsBridgeListener() {
                @Override
                public void onJsInteract(int actionType, JsCallbackResponse jsCallbackResponse) {
                    switch (actionType) {
                        case JsInteractType.LOGIN_ACTION: {
                            Map<String, Object> param = new HashMap<>();
                            param.put("code", 501);
                            param.put("message", "登录通知");
                            mChannel.invokeMethod("android", param);
                            break;
                        }
                        case JsInteractType.SHARE_ACTION: {
                            Map<String, Object> param = new HashMap<>();
                            param.put("code", 503);
                            param.put("message", "分享通知");
                            param.put("data", jsCallbackResponse.getResponseData());
                            mChannel.invokeMethod("android", param);
                            break;
                        }
                    }
                }
            });
        } else if ("reload".equals(method)) {
            myNativeView.reload();
        } else if ("synchronizeToken".equals(method)) {
            String tokenKey = methodCall.argument("token_key");
            String tokenValue = methodCall.argument("token_value");
            myNativeView.sync(new XEToken(tokenKey, tokenValue));
        } else if ("sysNot".equals(method)) {
            myNativeView.syncNot();
        } else if ("cancelLogin".equals(method)) {
            myNativeView.loginCancel();
        } else if ("share".equals(method)) {
            myNativeView.share();
        } else if ("goBack".equals(method)) {
            result.success(myNativeView.handlerBack());
        }
    }
}