import 'package:flutter/services.dart';

class XESDK {

  static MethodChannel channel;

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
}