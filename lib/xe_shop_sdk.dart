import 'dart:async';

import 'package:flutter/services.dart';
export 'src/xe_webview.dart';
export 'src/xe_sdk.dart';

class XeShopSdk {
  static const MethodChannel _channel =
  const MethodChannel('xe_shop_sdk');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
