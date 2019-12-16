#import "XeShopSdkPlugin.h"
#import "XEWebViewFactory.h"
#import <XEShopSDK/XEShopSDK.h>
#import "XEWebViewController.h"


static NSString *const CHANNEL_NAME = @"xe_shop_sdk";

@interface XeShopSdkPlugin()

@property(nonatomic, strong) XEWebViewController *XEWebViewVC;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, weak) UIColor *titleColor;
@property(nonatomic, weak) UIColor *navViewColor;

@end

@implementation XeShopSdkPlugin {
    XEWebView * _webView;
    
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    
    channel = [FlutterMethodChannel
               methodChannelWithName:CHANNEL_NAME
               binaryMessenger:[registrar messenger]];
    XeShopSdkPlugin *intance = [[XeShopSdkPlugin alloc] init];
    
    [registrar addMethodCallDelegate:intance channel: channel];
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
    } else if ([call.method isEqualToString: @"isLog"]) {
        NSDictionary *dict = call.arguments;
        BOOL isLog = dict[@"isLog"];
        XESDK.shared.config.enableLog = isLog;
    } else if ([call.method isEqualToString: @"open"]) {
        
        NSDictionary *dict = call.arguments;
        NSString *url = dict[@"url"];
        
        // 初始化 webview
        if (_XEWebViewVC == nil) {
            _XEWebViewVC = [[XEWebViewController alloc] init];
        }
        
        _XEWebViewVC.url = url;
        _XEWebViewVC.channel = channel;
        _XEWebViewVC.navTitle = _title;
        _XEWebViewVC.titleColor = _titleColor;
        _XEWebViewVC.navViewColor = _navViewColor;
        _XEWebViewVC.modalPresentationStyle = UIModalPresentationFullScreen;
        
        UIViewController *vc = UIApplication.sharedApplication.keyWindow.rootViewController;
        [vc presentViewController:_XEWebViewVC animated: YES completion:nil];
        
    } else if ([call.method isEqualToString: @"share"]) {
        [_webView share];
    } else if ([call.method isEqualToString: @"setNavStyle"]) {
        NSDictionary *dict = call.arguments;
        NSString *title = dict[@"title"];
        NSString *titleColor = dict[@"titleColor"];
        NSString *backgroundColor = dict[@"backgroundColor"];
        self.title = title;
        if (titleColor.length > 0) {
            self.titleColor = [self colorWithHexString:titleColor];
        }
        
        if (backgroundColor.length > 0) {
            self.navViewColor = [self colorWithHexString:backgroundColor];
        }
        
    }
}

- (UIColor *)colorWithHexString:(NSString *)stringToConvert {
    
    if (stringToConvert.length < 1) {
        return [UIColor lightGrayColor];
    }
    
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [self colorWithRGBHex:hexNum];
}

- (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}


@end

