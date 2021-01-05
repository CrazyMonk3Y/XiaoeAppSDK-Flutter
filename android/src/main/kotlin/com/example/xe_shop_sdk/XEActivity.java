package com.example.xe_shop_sdk;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Matrix;
import android.os.Bundle;
import android.os.Message;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.xiaoe.shop.webcore.core.XEToken;
import com.xiaoe.shop.webcore.core.XiaoEWeb;
import com.xiaoe.shop.webcore.core.bridge.JsBridgeListener;
import com.xiaoe.shop.webcore.core.bridge.JsCallbackResponse;
import com.xiaoe.shop.webcore.core.bridge.JsInteractType;

import java.util.ArrayList;

public class XEActivity extends AppCompatActivity {

    private XiaoEWeb xiaoEWeb;
    private LoginReceiver mLoginReceiver;

    private ImageView mBackImg;
    private ImageView mShareImg;
    private ImageView mCloseImg;
    private TextView mTitleTv;

    private String[] noTitleList = {
            "https://appoamtsmhy5043.h5.xiaoeknow.com",
            "https://appoamtsmhy5043.h5.xiaoeknow.com/",
            "https://appoamtsmhy5043.h5.xiaoeknow.com/homepage/10",
            "https://appoamtsmhy5043.h5.xiaoeknow.com/homepage/10/",
            "https://appoamtsmhy5043.h5.xiaoeknow.com/homepage/30",
            "https://appoamtsmhy5043.h5.xiaoeknow.com/homepage/30/",
            "https://appoamtsmhy5043.h5.xiaoeknow.com/homepage/50/",
            "https://appoamtsmhy5043.h5.xiaoeknow.com/homepage/50"
    };

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
        mBackImg = findViewById(R.id.xe_sdk_back_img);
        mCloseImg = findViewById(R.id.xe_sdk_close_img);
        mShareImg = findViewById(R.id.xe_sdk_share_img);
        mTitleTv = findViewById(R.id.xe_sdk_title_tv);

        Intent intent = getIntent();
        if (intent != null && intent.getStringExtra("shop_url") != null) {

            String url = intent.getStringExtra("shop_url");
//            boolean flag = true;
//            for (int i = 0; i < noTitleList.length; i++) {
//                if (noTitleList[i].equals(url)){
//                    flag = false;
//                }
//            }
//            if (flag) {
//                mTitleLayout.setVisibility(View.VISIBLE);
//            }else {
//                mTitleLayout.setVisibility(View.GONE);
//            }

            String title = intent.getStringExtra("title");
//            mTitleTv.setText("值得读");
            if (title != null)
                mTitleTv.setText(title);

            int titleFontSize = intent.getIntExtra("titleFontSize", 17);
            mTitleTv.setTextSize(titleFontSize);

            String titleColor = intent.getStringExtra("titleColor");
            if (titleColor != null)
                mTitleTv.setTextColor(Color.parseColor(titleColor));

            String backgroundColor = intent.getStringExtra("backgroundColor");
            if (backgroundColor != null)
                mTitleLayout.setBackgroundColor(Color.parseColor(backgroundColor));

            String backIconImageName = intent.getStringExtra("backIconImageName");
            if (backIconImageName != null) {
                Bitmap sdkBackIcon = zoomImg(backIconImageName);
                if (sdkBackIcon != null) {
                    mBackImg.setImageBitmap(sdkBackIcon);
                } else {
                    mBackImg.setImageResource(R.mipmap.xe_sdk_back_icon);
                }
            } else {
                mBackImg.setImageResource(R.mipmap.xe_sdk_back_icon);
            }

            String closeIconImageName = intent.getStringExtra("closeIconImageName");
            if (closeIconImageName != null) {
                Bitmap sdkCloseIcon = zoomImg(closeIconImageName);
                if (sdkCloseIcon != null) {
                    mCloseImg.setImageBitmap(sdkCloseIcon);
                } else {
                    mCloseImg.setImageResource(R.mipmap.xe_sdk_close_icon);
                }
            } else {
                mCloseImg.setImageResource(R.mipmap.xe_sdk_close_icon);
            }

            String shareIconImageName = intent.getStringExtra("shareIconImageName");
            if (shareIconImageName != null) {
                Bitmap sdkShareIcon = zoomImg(shareIconImageName);
                if (sdkShareIcon != null) {
                    mShareImg.setImageBitmap(sdkShareIcon);
                } else {
                    mShareImg.setImageResource(R.mipmap.xe_sdk_share_icon);
                }
            } else {
                mShareImg.setImageResource(R.mipmap.xe_sdk_share_icon);
            }

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
            WebView web = (WebView) xiaoEWeb.getRealWebView();
            web.setWebViewClient(new WebViewClient(){
                @Override
                public void onPageFinished(WebView view, String url) {
                    if (!xiaoEWeb.handlerBack()){
                        mBackImg.setVisibility(View.GONE);
                    }
                    super.onPageFinished(view, url);
                }
            });

        }
    }

    private void initEvent() {
        mBackImg.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (!xiaoEWeb.handlerBack()) {
//                    finish();
                }
            }
        });

        mShareImg.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                xiaoEWeb.share();
            }
        });

        mCloseImg.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
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
        xiaoEWeb.onResume();
    }

    @Override
    protected void onPause() {
        super.onPause();
        xiaoEWeb.onPause();
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (xiaoEWeb.handlerKeyEvent(keyCode, event))
            return true;
        return super.onKeyDown(keyCode, event);
    }

//    @Override
//    public void onBackPressed() {
//
//    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        unregisterReceiver(mLoginReceiver);
        xiaoEWeb.onDestroy();
    }

    private class LoginReceiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            String tokenKey = intent.getStringExtra("tokenKey");
            String tokenValue = intent.getStringExtra("tokenValue");
            if (!TextUtils.isEmpty(tokenKey) && !TextUtils.isEmpty(tokenValue)) {
                xiaoEWeb.sync(new XEToken(tokenKey, tokenValue));
            }
        }
    }

    int dpToPx(int dps) {
        return Math.round(getResources().getDisplayMetrics().density * dps);
    }

    public Bitmap zoomImg(String fileName) {
        try {
            float targetSize = (float) dpToPx(17);
            Bitmap bm = BitmapFactory.decodeStream(getAssets().open("flutter_assets/images/android/" + fileName + ".png"));
            // 获得图片的宽高
            int width = bm.getWidth();
            int height = bm.getHeight();
            // 计算缩放比例
            float scaleWidth = targetSize / width;
            float scaleHeight = targetSize / height;
            // 取得想要缩放的matrix参数
            Matrix matrix = new Matrix();
            matrix.postScale(scaleWidth, scaleHeight);
            // 得到新的图片
            return Bitmap.createBitmap(bm, 0, 0, width, height, matrix, true);
        } catch (Exception e) {
            return null;
        }
    }
}