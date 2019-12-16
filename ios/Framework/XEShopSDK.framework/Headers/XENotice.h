//
//  XENotice.h
//  XEShopSDK
//
//  Created by xiaoemac on 2019/4/30.
//  Copyright © 2019年 xiaoemac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 通知类型枚举

 - XENoticeTypeOther: 其他通知，用户无需关心
 - XENoticeTypeLogin: 登录通知
 - XENoticeTypeShare: 接收到分享请求的结果回调
 - XENoticeTypeReady: Web页面已准备好，分享接口可用
 */
typedef NS_ENUM(NSUInteger, XENoticeType) {
    XENoticeTypeOther = 0,
    XENoticeTypeLogin,
    XENoticeTypeShare,
    XENoticeTypeReady,
};

@interface XENotice : NSObject

/**
 通知类型
 */
@property (nonatomic, assign) XENoticeType type;

/**
 附带的数据
 */
@property (nonatomic, strong, nullable) id response;


@end

NS_ASSUME_NONNULL_END
