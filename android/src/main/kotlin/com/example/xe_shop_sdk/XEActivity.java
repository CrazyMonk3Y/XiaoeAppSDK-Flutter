package com.example.xe_shop_sdk;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Message;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
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
    private LoginReceiver mLoginReceiver;

    private ImageView mBackImg;
    private ImageView mShareImg;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getSupportActionBar().hide();
        setContentView(R.layout.activity_web);

        initView();
        initEvent();
    }

    private void initView() {
        RelativeLayout mTitleLayout = findViewById(R.id.xe_sdk_title_layout);
        TextView mTitleTv = findViewById(R.id.xe_sdk_title_tv);
        mBackImg = findViewById(R.id.xe_sdk_back_img);
        mShareImg = findViewById(R.id.xe_sdk_share_img);

        Intent intent = getIntent();
        if (intent != null && intent.getStringExtra("shop_url") != null) {
            String title = intent.getStringExtra("title");
            String titleColor = intent.getStringExtra("titleColor");
            mTitleTv.setText(title);
            mTitleTv.setTextColor(Color.parseColor(titleColor));

            String backgroundColor = intent.getStringExtra("backgroundColor");
            mTitleLayout.setBackgroundColor(Color.parseColor(backgroundColor));

            RelativeLayout webLayout = findViewById(R.id.web_layout);
            xiaoEWeb = XiaoEWeb.with(this)
                    .setWebParent(webLayout, new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT))
                    .useDefaultUI()
                    .useDefaultTopIndicator(Color.BLUE)
                    .buildWeb()
                    .loadUrl(intent.getStringExtra("shop_url"));
            String tokenKey = intent.getStringExtra("tokenKey");
            String tokenValue = intent.getStringExtra("tokenValue");
            xiaoEWeb.sync(new XEToken(tokenKey, tokenValue));
        }
    }

    private void initEvent() {
        mBackImg.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });

        mShareImg.setOnClickListener(new View.OnClickListener() {
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

        mLoginReceiver = new LoginReceiver();
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("XE_SDK_SYS_TOKEN");
        registerReceiver(mLoginReceiver, intentFilter);
    }

    @Override
    protected void onResume() {
        super.onResume();
        xiaoEWeb.webLifeCycle().onResume();
    }

    @Override
    protected void onPause() {
        super.onPause();
        xiaoEWeb.webLifeCycle().onPause();
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (xiaoEWeb.handlerKeyEvent(keyCode, event))
            return true;
        return super.onKeyDown(keyCode, event);
    }

    @Override
    protected void onDestroy() {
        unregisterReceiver(mLoginReceiver);
        super.onDestroy();
        xiaoEWeb.webLifeCycle().onDestroy();
    }

    private class LoginReceiver extends BroadcastReceiver{
        @Override
        public void onReceive(Context context, Intent intent) {
            String tokenKey = intent.getStringExtra("tokenKey");
            String tokenValue = intent.getStringExtra("tokenValue");
            if (!TextUtils.isEmpty(tokenKey) && !TextUtils.isEmpty(tokenValue)) {
                xiaoEWeb.sync(new XEToken(tokenKey, tokenValue));
            }
        }
    }
}
