//
//  HJPaymentModule.m
//  HJPaymentMoudleDemo
//
//  Created by 谢豪杰 on 2017/5/16.
//  Copyright © 2017年 谢豪杰. All rights reserved.
//

#import "HJPaymentService.h"
//#import "HJAliPaymentService.h"
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
          //  payment.paymentService = [[HJAliPaymentService alloc] init];
            break;
        case HJPaymentChannelUNinPay:
            payment.paymentService = [[HJUninPaymentService alloc] init];
            break;
        
        case HJPaymentChannelWX:
            payment.paymentService = [[HJWXPaymentService alloc] init];
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
      //      payment.paymentService = [[HJAliPaymentService alloc] init];
            break;
        case HJPaymentChannelUNinPay:
            payment.paymentService = [[HJUninPaymentService alloc] init];
            break;
            
        case HJPaymentChannelWX:
            payment.paymentService = [[HJWXPaymentService alloc] init];
            break;
            
            
        default:
            break;
    }
    [payment.paymentService registerAPP:appId];
    
}

@end
