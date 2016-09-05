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
@protocol CSAPManagerDelegate <NSObject>

@required
- (void)CSAPManagerDidReceiveProduct:(NSArray <SKProduct *> *)productArr;
- (void)CSAPManagerCompletePurchaseWithProductid:(NSString *)productIdent;
- (void)CSAPManagerRestorePurchaseWithProductid:(NSString *)productIdent;
- (void)CSAPManagerFailurePurchase;


@end

@interface CSAPManager : NSObject

CSSingletonH

@property (nonatomic, weak) id delegate;

- (void)requestProductWithId:(NSArray *)productIdArr;
- (BOOL)isCanMakePayments;
- (void)purchaseProduct:(SKProduct *)skProduct;

- (void)restorePurchase;

@end
