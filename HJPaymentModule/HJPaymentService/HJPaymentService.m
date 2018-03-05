//
//  HJPaymentModule.m
//  HJPaymentMoudleDemo
//
//  Created by 谢豪杰 on 2017/5/16.
//  Copyright © 2017年 谢豪杰. All rights reserved.
//

#import "HJPaymentService.h"
#import "HJAliPaymentService.h"
#import "HJWXPaymentService.h"
#import "HJUninPaymentService.h"

@implementation HJPaymentService

+(instancetype)shareInstance {
    static HJPaymentService * payment = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        payment = [[HJPaymentService alloc] init];
    });
    
    return payment;
}

+ (void)payWithOrder:(NSObject *)order paymentChannel:(HJPaymentChannel)paymentChannel viewController:(UIViewController *)viewController secheme:(NSString *)secheme resultHandle:(HJPayResultHandle)resultHandle {
    
    HJPaymentService * payment = [HJPaymentService shareInstance];
    payment.paymentService = nil;
    switch (paymentChannel) {
        case HJPaymentChannelAliPay:
            payment.paymentService = [HJAliPaymentService shareInstance];
            break;
        case HJPaymentChannelUNinPay:
            payment.paymentService = [HJUninPaymentService shareInstance];
            break;
        
        case HJPaymentChannelWX:
            payment.paymentService = [HJWXPaymentService shareInstance];
            break;
            
        
        default:
            break;
    }
    
    [payment.paymentService payWithOrder:order viewController:viewController secheme:secheme resultCallBack:resultHandle];
    
}

+ (void)registerAppID:(NSString *)appId paymentChannel:(HJPaymentChannel)paymentChannel {
    
    HJPaymentService * payment = [HJPaymentService shareInstance];
    payment.paymentService = nil;
    switch (paymentChannel) {
        case HJPaymentChannelAliPay:
            payment.paymentService = [HJAliPaymentService shareInstance];
            break;
        case HJPaymentChannelUNinPay:
            payment.paymentService = [HJUninPaymentService shareInstance];
            break;
            
        case HJPaymentChannelWX:
            payment.paymentService = [HJWXPaymentService shareInstance];
            break;
            
            
        default:
            break;
    }
    [payment.paymentService registerAPP:appId];
    
}

+ (BOOL)handleOpenUrl:(NSURL *)url {
    if([url.scheme hasPrefix:@"wx"])//微信
    {
 
        return [[HJWXPaymentService shareInstance] handleOpenURL:url];
    }
    else if([url.host isEqualToString:@"uppayresult"])//银联
    {
        return [[HJUninPaymentService shareInstance] handleOpenURL:url];
    }
    else if([url.host isEqualToString:@"safepay"])//支付宝
    {
        return [[HJAliPaymentService shareInstance] handleOpenURL:url];
    }
    return NO;
}

@end
