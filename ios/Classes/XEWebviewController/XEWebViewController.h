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

@property(nonatomic, strong) UIView *navView;

@property(nonatomic, copy) NSString *navTitle;
@property(nonatomic, weak) UIColor *titleColor;
@property(nonatomic, weak) UIColor *navViewColor;

@end

NS_ASSUME_NONNULL_END
