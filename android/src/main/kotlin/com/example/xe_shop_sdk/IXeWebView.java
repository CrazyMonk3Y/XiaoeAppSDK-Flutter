package com.example.xe_shop_sdk;

import com.xiaoe.shop.webcore.webview.FlutterCustWebView;
import java.util.Map;
import io.flutter.plugin.common.BinaryMessenger;

public interface IXeWebView {
    void getWebView(FlutterCustWebView wv, BinaryMessenger messenger, int id, Map<String, Object> params);
}