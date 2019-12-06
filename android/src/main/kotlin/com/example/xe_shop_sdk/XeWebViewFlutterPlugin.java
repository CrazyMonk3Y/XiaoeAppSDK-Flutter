package com.example.xe_shop_sdk;

import io.flutter.plugin.common.PluginRegistry;

public class XeWebViewFlutterPlugin {

    public static void registerWith(PluginRegistry registry, IXeWebView xeWebView) {
        final String key = XeWebViewFlutterPlugin.class.getCanonicalName();

        if (registry.hasPlugin(key)) return;

        PluginRegistry.Registrar registrar = registry.registrarFor(key);
        registrar.platformViewRegistry().registerViewFactory("com.xiaoe-tech.xewebview", new XeWebViewFactory(registrar.messenger(),xeWebView) );
    }
}
