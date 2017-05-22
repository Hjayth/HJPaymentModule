//
//  HJPaymentServiceProtocol.h
//  HJPaymentMoudleDemo
//
//  Created by 谢豪杰 on 2017/5/22.
//  Copyright © 2017年 谢豪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSInteger const kHJPayErrorCode = 400;
static NSString * _Nullable const kHJPaySuccessMessage =  @"支付成功";
static NSString * _Nullable const kHJPayFailureMessage = @"支付失败";
static NSString * _Nullable const kHJPayCancelMessage = @"支付取消";

/**
 *  支付结果状态码
 */
typedef NS_ENUM(NSInteger, HJPayResultStatus) {
    /**
     *  成功
     */
    HJPayResultStatusSuccess,
    /**
     *  失败
     */
    HJPayResultStatusFailure,
    /**
     *  取消
     */
    HJPayResultStatusCancel,
    /**
     *  正在处理中（目前只有Ali支付有用）
     */
    HJPayResultStatusProcessing,
    
    /**
     *  银联苹果支付，使用该状态判断
     *  支付取消，交易已发起，状态不确定，商户需查询商户后台确认支付状态
     */
    HJPayResultStatusUnknownCancel,
    /**
     *  第三方支付app未安装
     *  目前只有微信需要判断，微信无网页支付，支付宝和银联支持网页支付
     */
    HJPayResultStatusUnInstall
};

typedef void(^HJPayResultHandle)(HJPayResultStatus status, NSDictionary * __nullable info, NSError * __nullable error);


/**
 采用协议，使三方支付相应的payment模块可以根据协议requied和option实现
 */
@protocol HJPaymentServiceProtocol <NSObject>

@required


/**
 *  生成支付订单
 *
 *  @param charge Charge 对象(JSON 格式字符串 或 NSDictionary)
 */
- (NSObject * _Nonnull)generatePayOrder:(NSDictionary * _Nonnull)charge;


/**
 @bref  进行支付
 
 @param order 订单信息
 @param resultHandle 支付结果回调
 @param secheme 要调起的三方APP的配置URLSecheme
 */
- (void)payWithOrder:(NSObject * _Nonnull)order
             secheme:(NSString * _Nullable )secheme
              result:(_Nonnull HJPayResultHandle)resultHandle
;



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
      resultCallBack:(HJPayResultHandle _Nullable )resultHandle ;

@optional


/**
 @bref  判断客户端是否安装（主要是针对微信支付）
 
 @return 客户端是否安装
 */
- (BOOL)isInstalled;


/**
 * @bref 注册appid
 *
 * @param appID 三方支付的appid
 * @return 是否注册
 */
- (BOOL)registerAPP:( NSString * _Nonnull )appID;


/**
 当程序跳回来时候做的处理
 
 @param url url
 */
- (BOOL)handleOpenURL:(NSURL * _Nonnull)url;



/**
 开启debug模式（只针对alipay 和 银联支付）
 
 @param enabled 是否开启
 */
- (void)setDebugMode:(BOOL)enabled;


@end

@interface HJPaymentServiceProtocol : NSObject <HJPaymentServiceProtocol>

@property (nonatomic , copy) _Nonnull HJPayResultHandle  paymentHandle;

@end
