//
//  WXPaymentService.m
//  HJPaymentMoudleDemo
//
//  Created by 谢豪杰 on 2017/5/19.
//  Copyright © 2017年 谢豪杰. All rights reserved.
//

#import "HJWXPaymentService.h"
#import <WXApi.h>

@interface HJWXPaymentService ()<WXApiDelegate>

@end

@implementation HJWXPaymentService

+ (instancetype)shareInstance {
    static HJWXPaymentService * instance = nil;
    static dispatch_once_t  onceToken ;
    dispatch_once(&onceToken, ^{
        instance = [[HJWXPaymentService alloc] init];
    });
    return instance;

}

- (void)payWithOrder:(NSObject *)order viewController:(UIViewController *)viewController secheme:(NSString *)secheme resultCallBack:(HJPayResultHandle)resultHandle {
    if (![self isInstalled]) {
        NSError * error = [NSError errorWithDomain:NSStringFromClass(self.class) code:kHJPayErrorCode userInfo:@{NSLocalizedDescriptionKey:@"应用未安装"}];
        resultHandle(HJPayResultStatusUnInstall, nil, error);
        return;
    } else if (![WXApi isWXAppSupportApi]) {
        NSError *error = [NSError errorWithDomain:NSStringFromClass(self.class) code:kHJPayErrorCode userInfo:@{NSLocalizedDescriptionKey:@"该版本微信不支持支付"}];
        resultHandle(HJPayResultStatusCancel, nil, error);
        return;
    }
    
    PayReq * req = (PayReq *)order;
    //调用支付
    [WXApi sendReq:req];
    
    self.paymentHandle = resultHandle;

}


- (void)payWithOrder:(NSObject *)order result:(HJPayResultHandle)resultHandle secheme:(NSString * _Nullable)secheme{
  
    if (![self isInstalled]) {
        NSError * error = [NSError errorWithDomain:NSStringFromClass(self.class) code:kHJPayErrorCode userInfo:@{NSLocalizedDescriptionKey:@"应用未安装"}];
        
        if (resultHandle) {
            resultHandle(HJPayResultStatusUnInstall, nil, error);
             self.paymentHandle = resultHandle;
        }
        return;
    } else if (![WXApi isWXAppSupportApi]) {
        NSError *error = [NSError errorWithDomain:NSStringFromClass(self.class) code:kHJPayErrorCode userInfo:@{NSLocalizedDescriptionKey:@"该版本微信不支持支付"}];
        if (resultHandle) {
            resultHandle(HJPayResultStatusUnInstall, nil, error);
             self.paymentHandle = resultHandle;
        }
        return;
    }
    
    PayReq * req = (PayReq *)order;
    //调用支付
    [WXApi sendReq:req];

   
    
}

- (BOOL)isInstalled {
   return  [WXApi isWXAppInstalled];
}

- (NSObject *)generatePayOrder:(NSDictionary *)charge {
    //发送请求订单
    PayReq *req = [[PayReq alloc] init];
    req.partnerId = [charge objectForKey:@"partnerid"];
    req.prepayId = [charge objectForKey:@"prepayid"];
    req.nonceStr = [charge objectForKey:@"noncestr"];
    req.timeStamp = [[charge objectForKey:@"timestamp"] intValue];
    req.package = [charge objectForKey:@"packagevalue"];
    req.sign = [charge objectForKey:@"sign"];
    return req;

}

- (BOOL)handleOpenURL:(NSURL *)url {
    if ([url.scheme hasPrefix:@"wx"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;

}

- (NSDictionary *)errorMessage {
    return @{@(WXSuccess):kHJPaySuccessMessage,
             @(WXErrCodeCommon):kHJPayFailureMessage,
             @(WXErrCodeUserCancel):kHJPayCancelMessage
             };
}

#pragma mark 
#pragma mark --WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        HJPayResultStatus payResultStatus = HJPayResultStatusFailure;
        switch (resp.errCode) {
            case WXSuccess:
                payResultStatus = HJPayResultStatusSuccess;
                break;
            case WXErrCodeCommon:
                //这个错误码指定的错误范围比较广：签名错误、未注册appid
                payResultStatus = HJPayResultStatusFailure;
                break;
            case WXErrCodeUserCancel:
                payResultStatus = HJPayResultStatusCancel;
                break;
                
            default:
                break;
        }
    
        //组合error信息
    NSDictionary * errorMessageDic = [self errorMessage];
    NSString * errorDescription = resp.errStr;
    if (!errorDescription) {
        errorDescription = errorMessageDic[@(resp.errCode)];
    }
    NSError * error = [NSError errorWithDomain:NSStringFromClass(self.class) code:kHJPayErrorCode userInfo:@{NSLocalizedDescriptionKey:errorDescription}];
        if (self.paymentHandle) {
                self.paymentHandle(payResultStatus,errorMessageDic,error);
        }

        
         }
    
}


@end
