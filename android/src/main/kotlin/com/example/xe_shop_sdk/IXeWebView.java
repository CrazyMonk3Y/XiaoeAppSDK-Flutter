package com.example.xe_shop_sdk;

import com.xiaoe.shop.webcore.webview.XeWebLayout;
import java.util.Map;
import io.flutter.plugin.common.BinaryMessenger;

public interface IXeWebView {
    void getWebView(XeWebLayout wv, BinaryMessenger messenger, int id, Map<String, Object> params);
}