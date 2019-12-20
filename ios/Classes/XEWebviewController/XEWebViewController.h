//
//  XEWebViewController.h
//  Pods-Runner
//
//  Created by page on 2019/12/16.
//

#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface XEWebViewController : UIViewController

@property(nonatomic, copy) NSString *url;
@property(nonatomic, strong) FlutterMethodChannel *channel;

@property(nonatomic, copy) NSString *navTitle;
@property(nonatomic, strong) UIColor *titleColor;
@property(nonatomic, strong) UIColor *navViewColor;
@property(nonatomic, assign) CGFloat titleFontSize;

// 图标
@property(nonatomic, copy) NSString *backImageName;
@property(nonatomic, copy) NSString *shareImageName;
@property(nonatomic, copy) NSString *closeImageName;

@end

NS_ASSUME_NONNULL_END
