#import "XeShopSdkPlugin.h"
#import "XEWebViewFactory.h"
#import <XEShopSDK/XEShopSDK.h>

static NSString *const CHANNEL_NAME = @"xe_shop_sdk";

@implementation XeShopSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    
    channel = [FlutterMethodChannel
               methodChannelWithName:CHANNEL_NAME
               binaryMessenger:[registrar messenger]];
    XeShopSdkPlugin *intance = [[XeShopSdkPlugin alloc] init];
    
    [registrar addMethodCallDelegate:intance channel:channel];
    
    XEWebViewFactory *factory = [[XEWebViewFactory alloc] initWithMessenger:[registrar messenger]];
    [registrar registerViewFactory:factory withId:@"com.xiaoe-tech.xewebview"];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    
    if ([call.method isEqualToString: @"initConfig"]) {
        // MARK: 初始化
        // 参数
        NSDictionary *dict = call.arguments;
        NSString *clientId = dict[@"clientId"];
        NSString *appId = dict[@"appId"];
        NSString *scheme = dict[@"scheme"];
        
        XEConfig *config = [[XEConfig alloc] initWithClientId: clientId appId: appId];
        config.scheme = scheme;
        [XESDK.shared initializeSDKWithConfig:config];
    } else if ([call.method isEqualToString: @"synchronizeToken"]) {
        
        // MARK: 同步登录态
        // 参数
        NSDictionary *dict = call.arguments;
        NSString *token_key = dict[@"token_key"];
        NSString *token_value = dict[@"token_value"];
        
        [XESDK.shared synchronizeCookieKey:token_key cookieValue:token_value];
    } else if ([call.method isEqualToString: @"getSdkVersion"]) {
        NSString *version = XESDK.shared.version;
        result(version);
    } else if ([call.method isEqualToString: @"logoutSDK"]) {
        XESDK.shared.logout;
    } else if ([call.method isEqualToString: @"isLog"]) {
        NSDictionary *dict = call.arguments;
        BOOL isLog = dict[@"isLog"];
        XESDK.shared.config.enableLog = isLog;
    }
}



@end
