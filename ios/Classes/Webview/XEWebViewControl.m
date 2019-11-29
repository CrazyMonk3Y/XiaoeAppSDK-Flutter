//
//  XEWebViewControl.m
//  Pods-Runner
//
//  Created by page on 2019/11/26.
//

#import "XEWebViewControl.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <XEShopSDK/XEShopSDK.h>

@interface XEWebViewControl() <XEWebViewDelegate, XEWebViewNoticeDelegate>

@end

@implementation XEWebViewControl {
    //FlutterIosTextLabel 创建后的标识
    int64_t _viewId;
    XEWebView * _webView;
    //消息回调
    FlutterMethodChannel* _channel;
    BOOL htmlImageIsClick;
    NSMutableArray* mImageUrlArray;
}

-(instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger{
    if ([super init]) {
        
        // 接收 初始化参数 XEShopSDK
        NSDictionary *dic = args;
        NSString *clientId = dic[@"clientId"];
        NSString *appId = dic[@"appId"];
        NSString *scheme = dic[@"scheme"];
        
        if (frame.size.width == 0) {
            
            int defaultHeight = [UIScreen mainScreen].bounds.size.height - 64;
            
            if ([UIScreen mainScreen].bounds.size.height >= 812
                && [UIScreen mainScreen].bounds.size.height < 1024) {
                defaultHeight = [UIScreen mainScreen].bounds.size.height - 88;
            }
            
            if (dic[@"height"] != nil) {
                defaultHeight = [dic[@"height"] doubleValue];
            }
            
            frame = CGRectMake(frame.origin.x,
                               frame.origin.y,
                               [UIScreen mainScreen].bounds.size.width,
                               defaultHeight);
        }
        
        _webView = [[XEWebView alloc] initWithFrame:frame webViewType:XEWebViewTypeWKWebView];
        _webView.delegate = self;
        _webView.noticeDelegate = self;
        _viewId = viewId;
        
        XEConfig *config = [[XEConfig alloc] initWithClientId:clientId appId:appId];
        config.scheme = scheme;
        [XESDK.shared initializeSDKWithConfig:config];
        
        // 注册flutter 与 ios 通信通道
        NSString* channelName = [NSString stringWithFormat:@"com.xiaoe-tech.xewebview_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall *  call, FlutterResult  result) {
            [weakSelf onMethodCall:call result:result];
        }];
        
    }
    return self;
    
}

-(void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result{
    if ([[call method] isEqualToString:@"load"]) {
        // 加载链接
        NSDictionary *dict = call.arguments;
        NSString *url = dict[@"url"];
        NSURL *requestUrl = [NSURL URLWithString:url];
        NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
        [_webView loadRequest:request];
        
    } else if ([[call method] isEqualToString:@"reload"]) {
        if (_webView != nil) {
            [_webView reload];
        }
    } else if ([[call method] isEqualToString:@"share"]) {
        if (_webView != nil) {
            [_webView share];
        }
    } else if ([[call method] isEqualToString:@"goBack"]) {
        if (_webView != nil) {
            if ([_webView canGoBack]) {
                [_webView goBack];
            } else {
                // 已经不可 goBack 通知
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:[NSNumber numberWithInt:600] forKey:@"code"];
                [dict setObject:@"can not GoBack" forKey:@"message"];
                [dict setObject:@"" forKey:@"data"];
                
                [self messagePost:dict];
            }
        }
    } else if ([[call method] isEqualToString:@"stopLoading"]) {
        if (_webView != nil) {
            [_webView stopReloading];
        }
    } else if ([[call method] isEqualToString:@"cancelLogin"]) {
        if (_webView != nil) {
            [_webView cancelLogin];
        }
    }
}

- (nonnull UIView *)view {
    return _webView;
}

-(void) messagePost:(NSDictionary *)dict{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // UI更新代码
        [self->_channel invokeMethod:@"ios" arguments:dict];
    });
}

#pragma mark - XEWebViewNotice Delegate

- (void)webView:(id<XEWebView>)webView didReceiveNotice:(XENotice *)notice
{
    
    switch (notice.type) {
        case XENoticeTypeLogin:
        {
            // 登录通知
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:[NSNumber numberWithInt:501] forKey:@"code"];
            [dict setObject:@"登录通知" forKey:@"message"];
            [dict setObject:@"" forKey:@"data"];
            
            [self messagePost:dict];
            
        }
            break;
        case XENoticeTypeLogout:
        {
            // 退出通知
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:[NSNumber numberWithInt:502] forKey:@"code"];
            [dict setObject:@"退出通知" forKey:@"message"];
            [dict setObject:@"" forKey:@"data"];
            
            [self messagePost:dict];
        }
            break;
        case XENoticeTypeShare:
        {
            // 接收到分享请求的结果回调
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            NSDictionary *response = (NSDictionary *)notice.response;
            [dict setObject:[NSNumber numberWithInt:503] forKey:@"code"];
            [dict setObject:@"分享通知" forKey:@"message"];
            [dict setObject:response forKey:@"data"];
            [self messagePost:dict];
        }
            break;
        default:
            break;
    }
}

#pragma mark - XEWebViewDelegate Delegate (可选)

- (BOOL)webView:(id<XEWebView>)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(id<XEWebView>)webView
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInt:401] forKey:@"code"];
    [dict setObject:@"开始加载" forKey:@"message"];
    [dict setObject:@"success" forKey:@"data"];
    
    [self messagePost:dict];
}

- (void)webViewDidFinishLoad:(id<XEWebView>)webView
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInt:402] forKey:@"code"];
    [dict setObject:@"加载完成" forKey:@"message"];
    [dict setObject:@"success" forKey:@"data"];
    
    [self messagePost:dict];
}

- (void)webView:(id<XEWebView>)webView didFailLoadWithError:(NSError *)error
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInt:403] forKey:@"code"];
    [dict setObject:@"加载出错" forKey:@"message"];
    [dict setObject:@"error" forKey:@"data"];
    
    [self messagePost:dict];
}


@end
