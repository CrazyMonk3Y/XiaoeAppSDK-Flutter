package com.example.xe_shop_sdk;

import android.app.Activity;
import android.os.Bundle;
import android.view.ViewGroup;

import androidx.annotation.Nullable;

import com.xiaoe.shop.webcore.XiaoEWeb;
import com.xiaoe.shop.webcore.webview.FlutterCustWebView;

public class XEActivity extends Activity {
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        FlutterCustWebView myNativeView = new FlutterCustWebView(this);
        myNativeView.loadUrl("https://app38itOR341547.sdk.xiaoe-tech.com/");
        setContentView(myNativeView);



    }
}
