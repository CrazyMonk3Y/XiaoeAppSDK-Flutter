import 'package:flutter/services.dart';

enum XEWebType {

  Login, // 登录通知
  Share, // 分享通知

  StartLoad, // 开始加载
  FinishLoad, // 加载完成
  FailLoad,  // 加载出错

  RequestInputDialog,//仅android拉起输入框事件
}

class XESDK {

  static MethodChannel channel;

  /**
   * content 回调的基本数据
   * webviewType  回调的类型
   */
  static Function(dynamic content, XEWebType webviewType) callback;

  //
  static initConfig(String clientId, String appId,{String scheme}) async {
    channel = new MethodChannel('xe_shop_sdk');

    await channel.invokeMethod("initConfig", {"clientId": clientId, "appId": appId, "scheme": scheme});
  }

  static synchronizeToken(String tokenKey, String tokenValue) async {
    await channel.invokeMethod("synchronizeToken", {"token_key": tokenKey, "token_value": tokenValue});
  }

  static Future<String> getSdkVersion() async {
    return await channel.invokeMethod("getSdkVersion");
  }

  static logoutSdk() async {
    await channel.invokeMethod("logoutSDK");
  }

  static isLog(bool isOpen) async {
    await channel.invokeMethod("isLog", {"isLog": isOpen});
  }

  // 打开页面
  static open(String url, call) {
    if (channel == null) {
      channel = new MethodChannel('xe_shop_sdk');
    }
    channel.invokeMethod("open", {"url": url});

    callback = call;

    //设置监听
    nativeMessageListener();
  }

  static share() async {
    await channel.invokeMethod("share");
  }

  // 设置导航标题，背景颜色, 颜色16进制字符串（可以以#开头，例：#FFFFFF）
  static setNavStyle({String title, String titleColor, String titleFontSize, String backgroundColor}) {
    channel.invokeMethod("setNavStyle",
        {"title": title,
          "titleColor": titleColor,
          "backgroundColor": backgroundColor,
          "titleFontSize": titleFontSize});
  }

  // 设置返回按钮图片, 请把 Image 放到主工程
  static setBackButtonImage(String imageName) {
    if (imageName.isEmpty) {
      return;
    }
    channel.invokeMethod("setBackButtonImage", {"imageName": imageName});
  }

  // 设置分享按钮图片, 请把 Image 放到主工程
  static setShareButtonImage(String imageName) {
    if (imageName.isEmpty) {
      return;
    }
    channel.invokeMethod("setShareButtonImage", {"imageName": imageName});
  }

  // 设置分享按钮图片, 请把 Image 放到主工程
  static setCloseButtonImage(String imageName) {
    if (imageName.isEmpty) {
      return;
    }
    channel.invokeMethod("setCloseButtonImage", {"imageName": imageName});
  }

  //  /**
//   * 设置消息监听
//   * code
//   * 401 webview 开始加载
//   * 402 webview 加载完成
//   * 403 webview 加载出错

//   * 501 webview 登录通知
//   * 503 webview 分享通知

//   * 700 webView 弹输入框通知
//   *
//   * @param map
//   */
  static Future<dynamic> nativeMessageListener() async {
    // ignore: missing_return
    channel.setMethodCallHandler((resultCall) {

      // 处理原生 Android iOS 发送过来的消息
      MethodCall call = resultCall;
      String method = call.method;
      Map arguments = call.arguments;

      int code = arguments["code"];
      String message = arguments["message"];
      dynamic content = arguments["data"];

      print("nativeMessageListener");
      print(content);

      if (callback != null) {
        callbackContent(code, message, content);
      } else {
        print("native_webview callback is null ");
      }
    });
  }

  static callbackContent(int code, String message, dynamic content) {
    XEWebType type;
    switch(code) {
      case 401:
        type = XEWebType.StartLoad;
        break;
      case 402:
        type = XEWebType.FinishLoad;
        break;
      case 403:
        type = XEWebType.FailLoad;
        break;
      case 501:
        type = XEWebType.Login;
        break;
      case 503:
        type = XEWebType.Share;
        break;
      case 700:
        type = XEWebType.RequestInputDialog;
        break;
      default:
        break;
    }

    callback(content, type);
  }

}