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


+ (void)payWithOrder:(NSObject *)order paymentChannel:(HJPaymentChannel)paymentChannel viewController:(UIViewController *)viewController secheme:(NSString *)secheme resultHandle:(HJPayResultHandle)resultHandle;

+(void)registerAppID:(NSString *)appId paymentChannel:(HJPaymentChannel)
    paymentChannel;

@property (nonatomic , strong) HJPaymentServiceProtocol * paymentService;

@end
