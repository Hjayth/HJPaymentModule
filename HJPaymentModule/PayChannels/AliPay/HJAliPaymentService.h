//
//  AliPaymentService.h
//  HJPaymentMoudleDemo
//
//  Created by 谢豪杰 on 2017/5/18.
//  Copyright © 2017年 谢豪杰. All rights reserved.
//

#import "HJPaymentServiceProtocol.h"

@interface HJAliPaymentService : HJPaymentServiceProtocol

+ (instancetype)shareInstance;

@end
