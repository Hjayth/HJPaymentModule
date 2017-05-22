//
//  HJPaymentServiceProtocol.m
//  HJPaymentMoudleDemo
//
//  Created by 谢豪杰 on 2017/5/22.
//  Copyright © 2017年 谢豪杰. All rights reserved.
//

#import "HJPaymentServiceProtocol.h"

@implementation HJPaymentServiceProtocol

/**
 *  生成支付订单
 *
 *  @param charge Charge 对象(JSON 格式字符串 或 NSDictionary)
 */
- (NSObject * _Nonnull)generatePayOrder:(NSDictionary * _Nonnull)charge {

    return nil;
}


/**
 @bref  进行支付
 
 @param order 订单信息
 @param resultHandle 支付结果回调
 @param secheme 要调起的三方APP的配置URLSecheme
 */
- (void)payWithOrder:(NSObject * _Nonnull)order
             secheme:(NSString * _Nullable )secheme
              result:(_Nonnull HJPayResultHandle)resultHandle
{


}



/**
 @bref 支付
 
 @param order 订单信息
 @param viewController 调用支付的VC（这个主要是针对的是使用银联支付的情况，银联支付需要）
 @param resultHandle 结果回调
 @param secheme 要调起的三方APP的配置URLSecheme
 */
- (void)payWithOrder:( NSObject * _Nonnull )order
      viewController:( UIViewController * _Nullable )viewController
             secheme:(NSString * _Nullable )secheme
      resultCallBack:(HJPayResultHandle _Nullable )resultHandle {


}

@end
