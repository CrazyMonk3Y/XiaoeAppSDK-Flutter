import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xe_shop_sdk/xe_shop_sdk.dart';

void main() {
  const MethodChannel channel = MethodChannel('xe_shop_sdk');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await XeShopSdk.platformVersion, '42');
  });
}
