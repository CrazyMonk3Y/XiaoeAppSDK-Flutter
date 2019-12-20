#import "XeShopSdkPlugin.h"
#import <XEShopSDK/XEShopSDK.h>
#import "XEWebViewController.h"

#define NSNull2Nil(_x_) if([_x_ isKindOfClass: NSNull.class]) _x_ = nil;

static NSString *const CHANNEL_NAME = @"xe_shop_sdk";

@interface XeShopSdkPlugin()

@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) UIColor *titleColor;
@property(nonatomic, strong) UIColor *navViewColor;
@property(nonatomic, assign) CGFloat titleFontSize;

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
        
        NSNull2Nil(clientId);
        NSNull2Nil(appId);
        NSNull2Nil(scheme);
        
        XEConfig *config = [[XEConfig alloc] initWithClientId: clientId appId: appId];
        config.scheme = scheme;
        [XESDK.shared initializeSDKWithConfig:config];
        
    } else if ([call.method isEqualToString: @"synchronizeToken"]) {
        
        // MARK: 同步登录态
        NSDictionary *dict = call.arguments;
        NSString *token_key = dict[@"token_key"];
        NSString *token_value = dict[@"token_value"];
        NSNull2Nil(token_key);
        NSNull2Nil(token_value);
        
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
        NSNull2Nil(url);
        // 初始化 webview
        XEWebViewController *_XEWebViewVC = [[XEWebViewController alloc] init];
        _XEWebViewVC.url = url;
        _XEWebViewVC.channel = channel;
        _XEWebViewVC.navTitle = _title;
        _XEWebViewVC.titleFontSize = _titleFontSize;
        _XEWebViewVC.titleColor = _titleColor;
        _XEWebViewVC.navViewColor = _navViewColor;
        _XEWebViewVC.backImageName = _backImageName;
        _XEWebViewVC.shareImageName = _shareImageName;
        _XEWebViewVC.closeImageName = _closeImageName;
                
        _XEWebViewVC.modalPresentationStyle = UIModalPresentationFullScreen;
                
        UIViewController *vc = [self frontWindow].rootViewController;
        [vc presentViewController:_XEWebViewVC animated: YES completion:nil];
        
    } else if ([call.method isEqualToString: @"setNavStyle"]) {
        NSDictionary *dict = call.arguments;
        
        NSString *titleColor = dict[@"titleColor"];
        NSNumber *titleFontSize = dict[@"titleFontSize"];
        NSString *backgroundColor = dict[@"backgroundColor"];
        
        NSString *backIconImageName = dict[@"backIconImageName"];
        NSString *closeIconImageName = dict[@"closeIconImageName"];
        NSString *shareIconImageName = dict[@"shareIconImageName"];
        
        NSNull2Nil(titleColor);
        NSNull2Nil(titleFontSize);
        NSNull2Nil(backgroundColor);
        
        NSNull2Nil(backIconImageName);
        NSNull2Nil(closeIconImageName);
        NSNull2Nil(shareIconImageName);
        
        self.titleColor = [self colorWithHexString:titleColor alpha:1.0];
        if (titleFontSize) {
            self.titleFontSize = [titleFontSize floatValue];
        }
        self.navViewColor = [self colorWithHexString:backgroundColor alpha:1.0];

        _backImageName = backIconImageName;
        _closeImageName = closeIconImageName;
        _shareImageName = shareIconImageName;
        
    } else if ([call.method isEqualToString: @"setTitle"]) {
        NSDictionary *dict = call.arguments;
        NSString *title = dict[@"title"];
        NSNull2Nil(title);
        self.title = title;
    }
}


/**
16进制颜色转换为UIColor

@param hexColor 16进制字符串（可以以0x开头，可以以#开头，也可以就是6位的16进制）
@param opacity 透明度
@return 16进制字符串对应的颜色
*/
- (UIColor *)colorWithHexString:(NSString *)hexColor alpha:(float)opacity{
    
    if (hexColor == nil) return nil;
    
    NSString * cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    // String should be 6 or 8 characters
    if ([cString length] < 6) return nil;

    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];

    if ([cString length] != 6) return nil;

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

// 获取 window
- (UIWindow *)frontWindow {
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = window.windowLevel >= UIWindowLevelNormal;
        BOOL windowKeyWindow = window.isKeyWindow;
            
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported && windowKeyWindow) {
            return window;
        }
    }
    return UIApplication.sharedApplication.keyWindow;
}


@end

