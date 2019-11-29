import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum XEWebViewType {

  Login, // 登录通知
  Share, // 分享通知

  StartLoad, // 开始加载
  FinishLoad, // 加载完成
  FailLoad,  // 加载出错

  CanNotGoBack, // webview can not Goback
}

class XEWebView extends StatefulWidget {

  // 店铺 URL
  String url;

  /**
   * content 回调的基本数据
   * webviewType  回调的类型
   */
  Function(dynamic content, XEWebViewType webviewType) callback;


  XEWebView({
    this.url,
    this.callback,
  });

  @override
  State<StatefulWidget> createState() {
    viewState = new XEWebViewState(callback,url: url);
    return viewState;
  }

  XEWebViewState viewState;

  void loadUrl({String url}) async {
    NativeEventMessage.getDefault().post({
      "code": "loadUrl",
      "url": url,
    });
  }

  void reLoad() async {
    NativeEventMessage.getDefault().post({
      "code": "reLoad",
    });
  }


  void share() {
    NativeEventMessage.getDefault().post({
      "code": "share",
    });
  }

  void goBack() {
    NativeEventMessage.getDefault().post({
      "code": "goBack",
    });
  }

  void stopLoading() {
    NativeEventMessage.getDefault().post({
      "code": "stopLoading",
    });
  }

  void cancelLogin() {
    NativeEventMessage.getDefault().post({
      "code": "cancelLogin",
    });
  }

}

class XEWebViewState extends State<XEWebView> {
  // 加载的网页 URL
  String url;

  int viewId = -1;

  MethodChannel _channel;

  //回调
  Function(dynamic content, XEWebViewType webviewType) callback;

  XEWebViewState(this.callback,
      {this.url});

  @override
  void initState() {
    super.initState();
    NativeEventMessage.getDefault().register((event) {
      String code = event["code"];
      if (code == "reLoad") {
        String url = event["url"];
        if (url != null) {
          this.url = url;
        }
        reLoad();
      } else if (code == "loadUrl") {
        loadUrl();
      } else if (code == "share") {
        share();
      } else if (code == "goBack") {
        goBack();
      } else if (code == "stopLoading") {
        stopLoading();
      } else if (code == "cancelLogin") {
        cancelLogin();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    // NativeEventMessage.getDefault().unregister();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      //ios相关代码
      return buildIosWebView();
    } else if (Platform.isAndroid) {
      //android相关代码
      return buildAndroidWebView();
    } else {
      return Container();
    }
  }

//  /**
//   * 设置消息监听
//   * code
//   * 401 webview 开始加载
//   * 402 webview 加载完成
//   * 403 webview 加载出错

//   * 501 webview 登录通知
//   * 503 webview 分享通知

//   * 600 webview can not Goback
//   *
//   * @param map
//   */
  Future<dynamic> nativeMessageListener() async {
    // ignore: missing_return
    _channel.setMethodCallHandler((resultCall) {
      // 处理原生 Android iOS 发送过来的消息
      MethodCall call = resultCall;
      String method = call.method;
      Map arguments = call.arguments;

      int code = arguments["code"];
      String message = arguments["message"];
      dynamic content = arguments["data"];

      if (callback != null) {
        callbackContent(code, message, content);
      } else {
        print("native_webview callback is null ");
      }
    });
  }

  Widget buildAndroidWebView() {
    return AndroidView(
      //调用标识
      viewType: "com.xiaoe-tech.xewebview",
      //参数初始化
      creationParams: {
        "url": url,
      },
      //参数的编码方式
      creationParamsCodec: const StandardMessageCodec(),
      //webview 创建后的回调
      onPlatformViewCreated: (id) {
        viewId = id;
        print("onPlatformViewCreated " + id.toString());
        //创建通道
        _channel = new MethodChannel('com.xiaoe-tech.xewebview_$viewId');
        //设置监听
        nativeMessageListener();
        //加载页面
        loadUrl();
      },
    );
  }

  Widget buildIosWebView() {
    return UiKitView(
      //调用标识
      viewType: "com.xiaoe-tech.xewebview",
      //参数初始化
      creationParams: {
        "url": url,
      },
      //参数的编码方式
      creationParamsCodec: const StandardMessageCodec(),
      //webview 创建后的回调
      onPlatformViewCreated: (id) {
        viewId = id;
        //创建通道
        _channel = new MethodChannel('com.xiaoe-tech.xewebview_$viewId');
        //设置监听
        nativeMessageListener();
        //加载页面
        loadUrl();
      },
    );
  }

  void callbackContent(int code, String message, dynamic content) {
    XEWebViewType type;
    switch(code) {
      case 401:
        type = XEWebViewType.StartLoad;
        break;
      case 402:
        type = XEWebViewType.FinishLoad;
        break;
      case 403:
        type = XEWebViewType.FailLoad;
        break;
      case 501:
        type = XEWebViewType.Login;
        break;
      case 503:
        type = XEWebViewType.Share;
        break;
      case 600:
        type = XEWebViewType.CanNotGoBack;
        break;
      default:
        break;
    }

    callback(content, type);
  }

  void loadUrl() async {
    _channel.invokeMethod('load', {
      "url": url,
    });
  }

  void reLoad() async {
    _channel.invokeMethod('reload');
  }

  void share() async {
    _channel.invokeMethod('share');
  }

  void goBack() async {
    _channel.invokeMethod('goBack');
  }

  void stopLoading() async {
    _channel.invokeMethod('stopLoading');
  }

  void cancelLogin() {
    _channel.invokeMethod('cancelLogin');
  }
}


class NativeEventMessage{
  static NativeEventMessage _instance;
  //定义一个Controller
  StreamController _streamController;
  factory  NativeEventMessage.getDefault(){
    return _instance ??= NativeEventMessage._init();
  }

  //初始化
  NativeEventMessage._init(){
    _streamController = StreamController.broadcast();
  }

  //注册
  StreamSubscription<T> register<T>(void onData(T event)) {
    ///没有指定类型，全类型注册
    ///监听事件
    if (T == dynamic) {
      return _streamController.stream.listen(onData);
    } else {
      ///筛选出 类型为 T 的数据,获得只包含T的Stream
      Stream<T>stream = _streamController.stream.where((type) => type is T)
          .cast<T>();
      return stream.listen(onData);
    }
  }

  //发送消息
  void post(event) {
    _streamController.add(event);
  }

  //取消注册
  void unregister() {
    print("取消注册");
    _streamController.close();
  }


}