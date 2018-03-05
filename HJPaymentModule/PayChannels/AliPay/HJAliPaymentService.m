//
//  AliPaymentService.m
//  HJPaymentMoudleDemo
//
//  Created by 谢豪杰 on 2017/5/18.
//  Copyright © 2017年 谢豪杰. All rights reserved.
//

#import "HJAliPaymentService.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation HJAliPaymentService

+ (instancetype)shareInstance {
    static HJAliPaymentService * instance = nil;
    static dispatch_once_t  onceToken ;
    dispatch_once(&onceToken, ^{
        instance = [[HJAliPaymentService alloc] init];
    });
    return instance;
    
}

- (void)payWithOrder:(NSObject *)order secheme:(NSString *)secheme result:(HJPayResultHandle)resultHandle {
    
    [self payWithOrder:order viewController:nil secheme:secheme resultCallBack:resultHandle];
}


- (void)payWithOrder:(NSObject *)order viewController:(UIViewController *)viewController secheme:(NSString *)secheme resultCallBack:(HJPayResultHandle)resultHandle {
    if (resultHandle) {
        self.paymentHandle = resultHandle;
    }
    
    
    __weak __typeof(self)wself = self;
    [[AlipaySDK defaultService] payOrder:(NSString *)order fromScheme:secheme callback:^(NSDictionary *resultDic) {
        
        [wself analysisResultDic:resultDic];
    }];

}


- (BOOL)handleOpenURL:(NSURL *)url {
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [self analysisResultDic:resultDic];
        }];
    }
    return YES;

}

/**
 @bref 解析回调返回的结果字典

 @param resultDic 支付回调返回的结果字典
 */
- (void)analysisResultDic:(NSDictionary *)resultDic {
    
    
#ifdef DEBUG
    NSLog(@"reslut = %@", resultDic);
#endif
    HJPayResultStatus status;
    NSInteger resultStatus = [resultDic[@"resultStatus"] integerValue];
    if (resultStatus == 6001) {
        status = HJPayResultStatusCancel;
    } else if (resultStatus == 9000) {
        status = HJPayResultStatusSuccess;
    } else if (resultStatus == 8000) {
        status = HJPayResultStatusProcessing;
    } else {
        status = HJPayResultStatusFailure;
    }
    
    if (!resultDic || ![resultDic isKindOfClass:[NSDictionary class]]) {
        status = HJPayResultStatusFailure;
    }
    NSString *result = resultDic[@"result"];
    
    if (result && result.length) {
        
        NSDictionary *resultOrderDic = [[self class] separated:result byString:@"&"];
        NSString *validSuccess = resultOrderDic[@"success"];
        
        if (resultStatus == 9000 && [validSuccess isEqualToString:@"\"true\""]) {
            status = HJPayResultStatusSuccess;
        } else if (resultStatus == 6001){
            status = HJPayResultStatusCancel;
        } else if (resultStatus == 4000){
            status = HJPayResultStatusFailure;
        } else if (resultStatus == 8000) {
            status = HJPayResultStatusProcessing;
        }
    }
    
    NSString *message = [[self class] returnErrorMessage:resultStatus];
    
    NSError *error = [NSError errorWithDomain:NSStringFromClass(self.class) code:kHJPayErrorCode userInfo:@{NSLocalizedDescriptionKey:message}];
    if (self.paymentHandle) {
        self.paymentHandle(status, resultDic, error);
    }
    
    

}





/**
 返回自己定义的errorMessage

 @param status 状态码
 @return message内容
 */
+ (NSString *)returnErrorMessage:(NSInteger)status {
    NSDictionary *errorDic = [[self class] errorMessage];
    NSString *message = errorDic[@(status)];
    if (!message) {
        message = @"未知错误";
    }
    return message;
}


+ (NSDictionary *)errorMessage {
    return @{@9000: @"订单支付成功",
             @8000: @"正在处理中",
             @4000: @"订单支付失败",
             @6001: @"用户中途取消",
             @6002: @"网络连接出错"};
}

/**
 对数据进行分段

 @param string 分段内容
 @param byString 以什么为分段标准
 @return 拆分出来的段内容
 */
+ (NSDictionary *)separated:(NSString *)string byString:(NSString *)byString{
    NSAssert(string, @"string cann't be nil");
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *aa = string;
    NSArray *aaArray = [aa componentsSeparatedByString:byString];
    for (NSString *bb in aaArray) {
        NSRange range = [bb rangeOfString:@"="];
        NSString *key = [bb substringToIndex:(int)(range.location)];
        NSString *value = [bb substringFromIndex:(int)(range.location+1)];
        [dic setValue:value forKey:key];
    }
    return dic;
}

@end
