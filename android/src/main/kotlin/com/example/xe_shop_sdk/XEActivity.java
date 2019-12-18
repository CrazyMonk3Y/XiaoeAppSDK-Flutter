package com.example.xe_shop_sdk;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Message;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.xiaoe.shop.webcore.XEToken;
import com.xiaoe.shop.webcore.XiaoEWeb;
import com.xiaoe.shop.webcore.bridge.JsBridgeListener;
import com.xiaoe.shop.webcore.bridge.JsCallbackResponse;
import com.xiaoe.shop.webcore.bridge.JsInteractType;

public class XEActivity extends AppCompatActivity {

    private XiaoEWeb xiaoEWeb;
    private String title;
    private String titleColor;
    private String backgroundColor;
    private String tokenKey;
    private String tokenValue;

    private TextView mTitleTv;
    private TextView mBackTv;
    private TextView mShareTv;
    private RelativeLayout mTitleLayout;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getSupportActionBar().hide();
        setContentView(R.layout.activity_web);

        initView();
        initEvent();
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("XE_SDK_SYS_TOKEN");
        registerReceiver(new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                String tokenKey = intent.getStringExtra("tokenKey");
                String tokenValue = intent.getStringExtra("tokenValue");
                xiaoEWeb.sync(new XEToken(tokenKey, tokenValue));
            }
        }, intentFilter);
    }

    private void initView() {

        mTitleLayout = findViewById(R.id.xe_sdk_title_layout);
        mTitleTv = findViewById(R.id.xe_sdk_title_tv);
        mBackTv = findViewById(R.id.xe_sdk_back_tv);
        mShareTv = findViewById(R.id.xe_sdk_share_tv);

        Intent intent = getIntent();
        if (intent != null && intent.getStringExtra("shop_url") != null) {
            title = intent.getStringExtra("title");
            titleColor = intent.getStringExtra("titleColor");
            mTitleTv.setText(title);
            mTitleTv.setTextColor(Color.parseColor(titleColor));
            backgroundColor = intent.getStringExtra("backgroundColor");
            mTitleLayout.setBackgroundColor(Color.parseColor(backgroundColor));
            tokenKey = intent.getStringExtra("tokenKey");
            tokenValue = intent.getStringExtra("tokenValue");
            RelativeLayout webLayout = findViewById(R.id.web_layout);
            xiaoEWeb = XiaoEWeb.with(this)
                    .setWebParent(webLayout, new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT))
                    .useDefaultUI()
                    .useDefaultTopIndicator(Color.BLUE)
                    .buildWeb()
                    .loadUrl(intent.getStringExtra("shop_url"));

            xiaoEWeb.sync(new XEToken(tokenKey, tokenValue));
        }
    }

    private void initEvent() {
        mBackTv.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });

        mShareTv.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                xiaoEWeb.share();
            }
        });

        xiaoEWeb.setJsBridgeListener(new JsBridgeListener() {
            @Override
            public void onJsInteract(int actionType, JsCallbackResponse response) {
                switch (actionType) {
                    case JsInteractType.LOGIN_ACTION:
                        Message loginMsg = Message.obtain();
                        loginMsg.what = 0x110;
                        XeShopSdkPlugin.Companion.getHandler().sendMessage(loginMsg);
                        break;

                    case JsInteractType.SHARE_ACTION:
                        Message shareMsg = Message.obtain();
                        shareMsg.what = 0x111;
                        shareMsg.obj = response.getResponseData();
                        XeShopSdkPlugin.Companion.getHandler().sendMessage(shareMsg);
                        break;
                }
            }
        });
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (xiaoEWeb.handlerKeyEvent(keyCode, event))
            return true;
        return super.onKeyDown(keyCode, event);
    }
}
