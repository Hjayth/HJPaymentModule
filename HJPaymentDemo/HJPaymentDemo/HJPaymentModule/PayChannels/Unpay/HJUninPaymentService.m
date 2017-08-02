//
//  UninPaymentService.m
//  HJPaymentMoudleDemo
//
//  Created by 谢豪杰 on 2017/5/19.
//  Copyright © 2017年 谢豪杰. All rights reserved.
//

#import "HJUninPaymentService.h"
#import "UPPaymentControl.h"

static NSString * const kModeDebuge = @"01";
static NSString * const KModeDistribute = @"00";

@interface HJUninPaymentService ()

@property (nonatomic , copy) NSString * UnionPayMode;

@end

@implementation HJUninPaymentService

+ (instancetype)shareInstance {
    static HJUninPaymentService * instance = nil;
    static dispatch_once_t  onceToken ;
    dispatch_once(&onceToken, ^{
        instance = [[HJUninPaymentService alloc] init];
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
    NSString * orderStr = (NSString *)order;
    if (order && orderStr.length > 0) {
        [[UPPaymentControl defaultControl] startPay:orderStr fromScheme:secheme mode:self.UnionPayMode viewController:viewController];

    } else {
        
        NSError *error = [NSError errorWithDomain:NSStringFromClass(self.class) code:kHJPayErrorCode userInfo:@{NSLocalizedDescriptionKey:kHJPayFailureMessage}];
        if (self.paymentHandle) {
            self.paymentHandle(HJPayResultStatusFailure, nil, error);
        }
    }

}

- (BOOL)handleOpenURL:(NSURL *)url {
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        NSString *errorDescription = @"";
        HJPayResultStatus payresultStatus = HJPayResultStatusFailure;
        //结果code为成功时，先校验签名，校验成功后做后续处理
        if ([code isEqualToString:@"success"]) {
            errorDescription = kHJPaySuccessMessage;
            payresultStatus = HJPayResultStatusSuccess;
        } else if ([code isEqualToString:@"fail"]) {
            errorDescription = kHJPayFailureMessage;
            payresultStatus = HJPayResultStatusFailure;
            //交易失败
        } else if ([code isEqualToString:@"cancel"]) {
            //交易取消
            errorDescription = kHJPayCancelMessage;
            payresultStatus = HJPayResultStatusCancel;
        }
        
        NSError *error = [NSError errorWithDomain:NSStringFromClass(self.class) code:kHJPayErrorCode userInfo:@{NSLocalizedDescriptionKey:errorDescription}];
        if (self.paymentHandle) {
            self.paymentHandle(payresultStatus, data, error);
        }
    }];
    return YES;
}


- (void)setDebugMode:(BOOL)enabled {
    self.UnionPayMode = enabled ? kModeDebuge : KModeDistribute;
}

@end
