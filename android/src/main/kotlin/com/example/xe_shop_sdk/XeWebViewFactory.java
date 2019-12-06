package com.example.xe_shop_sdk;

import android.content.Context;
import java.util.Map;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class XeWebViewFactory extends PlatformViewFactory {
    private final BinaryMessenger messenger;
    private IXeWebView webView;

    public XeWebViewFactory(BinaryMessenger messenger, IXeWebView webView) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
        this.webView = webView;
    }

    @SuppressWarnings("unchecked")
    @Override
    public PlatformView create(Context context, int id, Object args) {
        Map<String, Object> params = (Map<String, Object>) args;
        return new XeWebView(context, messenger, id, params, webView);
    }
}