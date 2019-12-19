#import "XeShopSdkPlugin.h"
#import "XEWebViewFactory.h"
#import <XEShopSDK/XEShopSDK.h>
#import "XEWebViewController.h"


static NSString *const CHANNEL_NAME = @"xe_shop_sdk";

@interface XeShopSdkPlugin()

//@property(nonatomic, strong) XEWebViewController *XEWebViewVC;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) UIColor *titleColor;
@property(nonatomic, strong) UIColor *navViewColor;

// 图标
@property(nonatomic, copy) NSString *backImageName;
@property(nonatomic, copy) NSString *shareImageName;
@property(nonatomic, copy) NSString *closeImageName;

@end

@implementation XeShopSdkPlugin

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
        XEWebViewController *_XEWebViewVC = [[XEWebViewController alloc] init];
        _XEWebViewVC.url = url;
        _XEWebViewVC.channel = channel;
        _XEWebViewVC.navTitle = _title;
        _XEWebViewVC.titleColor = _titleColor;
        _XEWebViewVC.navViewColor = _navViewColor;
        _XEWebViewVC.backImageName = _backImageName;
        _XEWebViewVC.shareImageName = _shareImageName;
        _XEWebViewVC.closeImageName = _closeImageName;
                
        _XEWebViewVC.modalPresentationStyle = UIModalPresentationFullScreen;
        
        UIViewController *vc = UIApplication.sharedApplication.keyWindow.rootViewController;
        [vc presentViewController:_XEWebViewVC animated: YES completion:nil];
        
    } else if ([call.method isEqualToString: @"share"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"webView_share" object:nil];
    } else if ([call.method isEqualToString: @"setNavStyle"]) {
        NSDictionary *dict = call.arguments;
        NSString *title = dict[@"title"];
        NSString *titleColor = dict[@"titleColor"];
        NSString *backgroundColor = dict[@"backgroundColor"];
        
        self.title = title;
        self.titleColor = [self colorWithHexString:titleColor alpha:1.0];
        self.navViewColor = [self colorWithHexString:backgroundColor alpha:1.0];
        
    } else if ([call.method isEqualToString: @"setBackButtonImage"]) {
        NSDictionary *dict = call.arguments;
        _backImageName = dict[@"imageName"];
    } else if ([call.method isEqualToString: @"setShareButtonImage"]) {
        NSDictionary *dict = call.arguments;
        _shareImageName = dict[@"imageName"];
    } else if ([call.method isEqualToString: @"setCloseButtonImage"]) {
        NSDictionary *dict = call.arguments;
        _closeImageName = dict[@"imageName"];
    }
}

/**
16进制颜色转换为UIColor

@param hexColor 16进制字符串（可以以0x开头，可以以#开头，也可以就是6位的16进制）
@param opacity 透明度
@return 16进制字符串对应的颜色
*/
- (UIColor *)colorWithHexString:(NSString *)hexColor alpha:(float)opacity{
    NSString * cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];

    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];

    if ([cString length] != 6) return [UIColor blackColor];

    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString * rString = [cString substringWithRange:range];

    range.location = 2;
    NSString * gString = [cString substringWithRange:range];

    range.location = 4;
    NSString * bString = [cString substringWithRange:range];

    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:opacity];
}


@end

