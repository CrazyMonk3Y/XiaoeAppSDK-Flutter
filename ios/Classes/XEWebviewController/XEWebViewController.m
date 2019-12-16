//
//  XEWebViewController.m
//  Pods-Runner
//
//  Created by page on 2019/12/16.
//

#import "XEWebViewController.h"
#import <XEShopSDK/XEShopSDK.h>


@interface XEWebViewController ()<XEWebViewDelegate, XEWebViewNoticeDelegate>

@property(nonatomic, strong) XEWebView *webView;

@end

@implementation XEWebViewController

- (void)dealloc
{
    NSLog(@"XEWebViewController dealloc");
    _webView.noticeDelegate = nil;
    _webView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
}


- (void)setUp {
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    int navHeight = 64;
    if ([UIScreen mainScreen].bounds.size.height >= 812
        && [UIScreen mainScreen].bounds.size.height < 1024) {
        navHeight = 88;
    }
    
    // nav view
    _navView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, navHeight)];
    _navView.backgroundColor = _navViewColor;
    [self.view addSubview:_navView];
    
    // back button
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 40, 40, 40)];
    [backBtn setTitle:@"返回" forState: UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:backBtn];
    
    // back button
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 15 - 40,  40, 40, 40)];
    [shareBtn setTitle:@"分享" forState: UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:shareBtn];
    
    // title
    UILabel *title = [[UILabel alloc] init];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = self.navTitle;
    title.textColor = _titleColor;
    title.frame = CGRectMake(80, 40, [[UIScreen mainScreen] bounds].size.width - 160, 40);
    [_navView addSubview:title];
    
    CGRect webFrame = CGRectMake(0, navHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - navHeight);
    UIView *contentView = [[UIView alloc] initWithFrame:webFrame];
    [self.view addSubview:contentView];
    
    _webView = [[XEWebView alloc] initWithFrame:contentView.bounds webViewType:XEWebViewTypeWKWebView];
    _webView.delegate = self;
    _webView.noticeDelegate = self;
    [contentView addSubview:_webView];
    
    NSURL *requestUrl = [NSURL URLWithString:_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
    [_webView loadRequest:request];
}

- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationFullScreen;
}

 - (void) backBtnAction {
     [self dismissViewControllerAnimated:YES completion:nil];
 }

 - (void) shareBtnAction {
     [_webView share];
 }

 -(void) messagePost:(NSDictionary *)dict{
     
     dispatch_async(dispatch_get_main_queue(), ^{
         [self.channel invokeMethod:@"ios" arguments:dict];
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
