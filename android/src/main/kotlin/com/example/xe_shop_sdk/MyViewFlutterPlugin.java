package com.example.xe_shop_sdk;

import io.flutter.plugin.common.PluginRegistry;

public class MyViewFlutterPlugin {

    public static void registerWith(PluginRegistry registry, IWebView xeWebView) {
        final String key = MyViewFlutterPlugin.class.getCanonicalName();

        if (registry.hasPlugin(key)) return;

        PluginRegistry.Registrar registrar = registry.registrarFor(key);
        registrar.platformViewRegistry().registerViewFactory("com.xiaoe-tech.xewebview", new MyViewFactory(registrar.messenger(),xeWebView) );
    }
}
