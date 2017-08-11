//
//  CSAPManager.h
//  内购-VideoShow
//
//  Created by arduomeng on 16/8/25.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "CSSingleton.h"

typedef NS_ENUM(NSInteger, IAPFiledCode) {
    /**
     *  苹果返回错误信息
     */
    IAP_FILEDCOED_APPLECODE = 0,
    
    /**
     *  用户禁止应用内付费购买
     */
    IAP_FILEDCOED_NORIGHT = 1,
    
    /**
     *  商品为空
     */
    IAP_FILEDCOED_EMPTYGOODS = 2,
    /**
     *  无法获取产品信息，请重试
     */
    IAP_FILEDCOED_CANNOTGETINFORMATION = 3,
    /**
     *  购买失败，请重试
     */
    IAP_FILEDCOED_BUYFILED = 4,
    /**
     *  用户取消交易
     */
    IAP_FILEDCOED_USERCANCEL = 5
    
};

@protocol CSAPManagerDelegate <NSObject>

@required
- (void)CSAPManagerDidReceiveProduct:(NSArray <SKProduct *> *)productArr;
- (void)CSAPManagerCompletePurchaseWithProductid:(NSString *)productIdent;
- (void)CSAPManagerRestorePurchaseWithProductid:(NSString *)productIdent;
- (void)CSAPManagerFailurePurchase;


- (void)filedWithErrorCode:(NSInteger)errorCode andError:(NSString *)error; //失败
- (void)successRestoredPurchaseOfId : (SKPaymentQueue *)queue;
- (void)failedRestoredPurchaseOfId : (NSString *)errorDescripiton;

@end

@interface CSAPManager : NSObject

CSSingletonH

@property (nonatomic, weak) id delegate;

- (void)requestProductWithId:(NSArray *)productIdArr;
- (BOOL)isCanMakePayments;
- (void)purchaseProduct:(SKProduct *)skProduct;

- (void)restorePurchase;


@end
