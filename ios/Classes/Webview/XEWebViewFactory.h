//
//  XEWebViewFactory.h
//  Pods-Runner
//
//  Created by page on 2019/11/26.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface XEWebViewFactory : NSObject<FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject*)messager;
@end

NS_ASSUME_NONNULL_END
