import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xe_shop_sdk/xe_shop_sdk.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'dart:convert' show json;

void main() => runApp(
    MyApp()
);


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: WebViewDemo(),
    );
  }
}

class WebViewDemo extends StatefulWidget {
  @override
  WebViewDemoState createState() => WebViewDemoState();
}

class WebViewDemoState extends State<WebViewDemo> {

  String clientId = "883pzzGyzynE72G";
  String appId = "app38itOR341547";
  String url = 'https://apprnDA0ZDw4581.sdk.xiaoe-tech.com';
  String secretKey = "dfomGwT7JRWWnzY3okZ6yTkHtgNPTyhr";

  @override
  void initState() {
    super.initState();

    // 初始化 SDK
    XESDK.initConfig(clientId, appId);

    // 获取 token
    login();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      appBar: AppBar(
          title: Text('XEWebView demo')
      ),
      body: Center(
        child: FlatButton(
          onPressed: () {
            _open();
          },
          child: Text(
            "Open WebView Demo ",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.black,
        ),
      ),
    );
  }

  _open() {
    //设置标题
    XESDK.setTitle("Demo");

    // 设置导航样式

    XESDK.setNavStyle(
        titleColor: "#000000",
        titleFontSize:30,
        backgroundColor: "#FBFBFD",
        backIconImageName: "xe_sdk_back_icon",
        closeIconImageName: "xe_sdk_close_icon",
        shareIconImageName: "xe_sdk_share_icon"
    );

    // 打开 SDK WebView
    XESDK.open(url, _callBack);
  }


  _callBack(data, type) {
    if(type == XEWebType.Share){
      //分享弹吐司（这里用户根据自己的业务实现分享功能）
      Fluttertoast.showToast(msg: data);
    } else if(type == XEWebType.Login){
      //拉起登录弹窗（这里用户根据自己的业务实现登录功能）
      print("登录");
      login();
    }
  }

  // 获取 token
  void login() async {
    BaseOptions options = new BaseOptions(
        connectTimeout: 1000 * 10,
        receiveTimeout: 1000 * 5,
        responseType: ResponseType.plain
    );
    Dio dio = new Dio(options);
    //下面的登录态请求仅作Demo用，建议用户在自己的App后台调用SDK登录两个接口，然后App后台给App提供一个登录接口
    Response tokenResponse;
    tokenResponse = await dio.post("https://app38itOR341547.sdk.xiaoe-tech.com/sdk_api/xe.account.login.test/1.0.0",
        data: {"user_id": "123",
          "app_user_id": "123",
          "secret_key": secretKey,
          "sdk_app_id": clientId,
          "app_id": appId});
    Map tokenMap = json.decode(tokenResponse.data.toString());
    print("token");
    print(tokenMap);

    // 同步登录态 token
    XESDK.synchronizeToken(tokenMap['data']['token_key'], tokenMap['data']['token_value']);
  }
}