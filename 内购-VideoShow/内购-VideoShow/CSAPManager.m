//
//  CSAPManager.m
//  内购-VideoShow
//
//  Created by arduomeng on 16/8/25.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import "CSAPManager.h"

@interface CSAPManager () <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic, strong) SKProduct *currentProduct;


@end

@implementation CSAPManager

CSSingletonM

/** TODO:请求商品*/
- (void)requestProductWithId:(NSArray *)productIdArr {
    
    if (productIdArr.count > 0) {
        
        SKProductsRequest *productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:productIdArr]];
        
        // 设置SKProductsRequestDelegate
        productRequest.delegate = self;
        
        // 添加paymentTransactionObserver
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        [productRequest start];
    } else {
        NSLog(@"商品ID为空");
    }
}

- (BOOL)isCanMakePayments {
    if ([SKPaymentQueue canMakePayments]) {
        return YES;
    }else {
        NSLog(@"失败,用户禁止应用内付费购买.");
    }
    return NO;
}

// SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSArray *myProductArray = response.products;
    if (myProductArray && myProductArray.count > 0) {
        [self.delegate CSAPManagerDidReceiveProduct:response.products];
    } else {
        NSLog(@"无法获取产品信息，购买失败。");
        [self filedWithErrorCode:IAP_FILEDCOED_APPLECODE error:NSLocalizedString(@"Request Failed And Data Error" ,nil)];
    }
    
    
    
}


// SKProductsRequestDelegate <SKRequestDelegate>
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"------------------错误-----------------:%@", error);
}

- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"------------商品列表请求结束-----------------");
}


/** TODO:购买商品*/
- (void)purchaseProduct:(SKProduct *)skProduct {
    
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:skProduct];
    self.currentProduct = skProduct;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

// 非消耗品恢复操作
- (void)restorePurchase {
    
    if ([SKPaymentQueue canMakePayments]) {
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    }else {
        NSLog(@"恢复失败,用户禁止应用内付费购买.");
    }
}

#pragma mark - 实现SKPaymentQueue的回调方法
/*
 队列中的交易发生改变时,就会调用该方法
 */
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    /*
     SKPaymentTransactionStatePurchasing,    正在购买
     SKPaymentTransactionStatePurchased,     已经购买(购买成功)
     SKPaymentTransactionStateFailed,        购买失败
     SKPaymentTransactionStateRestored,      恢复购买
     SKPaymentTransactionStateDeferred       未决定
     */
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"用户正在购买 %@", self.currentProduct.localizedTitle);
                break;
                
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            // 当调用restorePurchase方法的时候已经下载过的商品会来到这里
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateDeferred:
                NSLog(@"未决定交易延迟");
                break;
            default:
                break;
        }
    }
}

// 恢复出现出错
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    if (error.code != SKErrorPaymentCancelled  && error.code != SKErrorUnknown)
    {
        [_delegate failedRestoredPurchaseOfId :error.localizedDescription];
    }
}

// 所有商品恢复完成
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"All restorable transactions have been processed by the payment queue.");
    [_delegate successRestoredPurchaseOfId :queue];
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    NSString* productIdent = transaction.payment.productIdentifier;
    
    // 验证交易 videoShow中没有进行验证
    if ([self verifyPurchaseWithPaymentTransaction]) {
        
        NSLog(@"购买成功 %@", self.currentProduct.localizedTitle);
        
        [self.delegate CSAPManagerCompletePurchaseWithProductid:productIdent];
    }else{
        // 提示用户
    }
    
    // 移除交易对列
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    if (transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"购买失败 %@", transaction.error.localizedDescription);
        [self.delegate CSAPManagerFailurePurchase];
    }else{
        NSLog(@"用户取消购买操作");
    }
    // 移除交易对列
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"恢复商品,将对应的商品给用户 %@", transaction.payment.productIdentifier);
    [self.delegate CSAPManagerRestorePurchaseWithProductid:transaction.payment.productIdentifier];
    
    // 移除交易对列
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}



//沙盒测试环境验证
#define SANDBOX @"https://sandbox.itunes.apple.com/verifyReceipt"
//正式环境验证
#define AppStore @"https://buy.itunes.apple.com/verifyReceipt"


-(BOOL)verifyPurchaseWithPaymentTransaction{
    
    //从沙盒中获取交易凭证并且拼接成请求体数据
    
    NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];
    
    NSString *receiptString=[receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串
    
    /*
    if (receiptString.length > 0) {
        // 向自己的服务器验证购买凭证（此处应该考虑将凭证本地保存,对服务器有失败重发机制）
     
         服务器要做的事情:
         接收ios端发过来的购买凭证。
         判断凭证是否已经存在或验证过，然后存储该凭证。
         将该凭证发送到苹果的服务器验证，并将验证结果返回给客户端。
         如果需要，修改用户相应的会员权限
     
    }*/
    
    // 这里直接由客户端进行验证
    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receiptString];
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    //创建请求到苹果官方进行购买验证
    
    NSURL *url=[NSURL URLWithString:SANDBOX];
    NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url];
    requestM.HTTPBody=bodyData;
    requestM.HTTPMethod=@"POST";
    
    //创建连接并发送同步请求
    NSError *error=nil;
    NSData *responseData=[NSURLConnection sendSynchronousRequest:requestM returningResponse:nil error:&error];
    if (error) {
        NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
        return NO;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"responseData : %@",dic);
    
    if([dic[@"status"] intValue]==0){
        NSLog(@"验证成功！");
        NSDictionary *dicReceipt= dic[@"receipt"];
        NSDictionary *dicInApp=[dicReceipt[@"in_app"] firstObject];
        NSString *productIdentifier= dicInApp[@"product_id"];//读取产品标识
        
        //在此处对购买记录进行存储，可以存储到开发商的服务器端
        return YES;
    }else{
        NSLog(@"购买失败，未通过验证！");
        return NO;
    }
    
}

#pragma mark 错误信息反馈
- (void)filedWithErrorCode:(NSInteger)code error:(NSString *)error {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(filedWithErrorCode:andError:)]) {
        switch (code) {
            case IAP_FILEDCOED_APPLECODE:
                [self.delegate filedWithErrorCode:IAP_FILEDCOED_APPLECODE andError:error];
                break;
                
            case IAP_FILEDCOED_NORIGHT:
                [self.delegate filedWithErrorCode:IAP_FILEDCOED_NORIGHT andError:nil];
                break;
                
            case IAP_FILEDCOED_EMPTYGOODS:
                [self.delegate filedWithErrorCode:IAP_FILEDCOED_EMPTYGOODS andError:nil];
                break;
                
            case IAP_FILEDCOED_CANNOTGETINFORMATION:
                [self.delegate filedWithErrorCode:IAP_FILEDCOED_CANNOTGETINFORMATION andError:nil];
                break;
                
            case IAP_FILEDCOED_BUYFILED:
                [self.delegate filedWithErrorCode:IAP_FILEDCOED_BUYFILED andError:nil];
                break;
                
            case IAP_FILEDCOED_USERCANCEL:
                [self.delegate filedWithErrorCode:IAP_FILEDCOED_USERCANCEL andError:nil];
                break;
                
            default:
                break;
        }
    }
}


@end
