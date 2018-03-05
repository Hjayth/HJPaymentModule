//
//  HJPaymentModule.h
//  HJPaymentMoudleDemo
//
//  Created by 谢豪杰 on 2017/5/16.
//  Copyright © 2017年 谢豪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HJPaymentServiceProtocol.h"


/**
 支付渠道

*/
typedef NS_ENUM(NSInteger , HJPaymentChannel){
    /**
     *  alipay支付渠道
     */
    HJPaymentChannelAliPay,
    /**
     *  银联支付渠道
     */
    HJPaymentChannelUNinPay,
    /**
     *  微信支付渠道
     */
    HJPaymentChannelWX,

};

@interface HJPaymentService : NSObject


/**
 支付订单

 @param order order信息
 @param paymentChannel 支付渠道
 @param viewController 支付所在VC
 @param secheme 对应的secheme
 @param resultHandle 结果回调
 */
+ (void)payWithOrder:(NSObject *)order paymentChannel:(HJPaymentChannel)paymentChannel viewController:(UIViewController *)viewController secheme:(NSString *)secheme resultHandle:(HJPayResultHandle)resultHandle;

/**
 注册AppID

 @param appId appID
 @param paymentChannel 支付渠道
 */
+(void)registerAppID:(NSString *)appId paymentChannel:(HJPaymentChannel)
    paymentChannel;

/**
 handleOpenUrl

 @param url url
 
 @return handle结果
 */
+ (BOOL)handleOpenUrl:(NSURL *)url;

@property (nonatomic , strong) HJPaymentServiceProtocol * paymentService;

@end
