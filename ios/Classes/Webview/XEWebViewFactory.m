//
//  XEWebViewFactory.m
//  Pods-Runner
//
//  Created by page on 2019/11/26.
//

#import "XEWebViewFactory.h"
#import "XEWebViewControl.h"

@implementation XEWebViewFactory{
    NSObject*_messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messager{
    self = [super init];
    if (self) {
        _messenger = messager;
    }
    return self;
}

-(NSObject<FlutterMessageCodec> *)createArgsCodec{
    return [FlutterStandardMessageCodec sharedInstance];
}

//创建原生视图封装实例
-(NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args{
    XEWebViewControl *activity = [[XEWebViewControl alloc] initWithWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
    return activity;
}
@end

