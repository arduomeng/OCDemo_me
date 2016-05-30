//
//  ViewController.m
//  02-内购
//
//  Created by xiaomage on 15/8/12.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import <StoreKit/StoreKit.h>

@interface ViewController () <SKProductsRequestDelegate, UITableViewDataSource, UITableViewDelegate, SKPaymentTransactionObserver>

/** 所有的商品的数组 */
@property (nonatomic, strong) NSArray *products;

- (IBAction)restore:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 去自己的服务器请求所有想卖商品的ProductIds
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"iapdemo.plist" ofType:nil];
    NSArray *productArray = [NSArray arrayWithContentsOfFile:filePath];
    NSArray *productIdArray = [productArray valueForKeyPath:@"productId"];
    
    // 去苹果服务器请求可卖的商品
    NSSet *productIdSet = [NSSet setWithArray:productIdArray];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdSet];
    request.delegate = self;
    [request start];
}

/**
 *   将观察者添加到此处的目的： 当有多个页面都需要进行内购的时候，将观察者设置为当前控制器。并且在willDisappear移除观察者
 *
 *  @param animated <#animated description#>
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 3.添加观察者(代理是一对一的关系/观察者一对多)
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 移除观察者
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

#pragma mark - 实现SKProductsRequest的代理方法
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    // 展示商品
    self.products = [response.products sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(SKProduct *obj1, SKProduct *obj2) {
        return [obj1.price compare:obj2.price];
    }];
    
    // 2.刷新表格
    [self.tableView reloadData];
}

#pragma mark - 实现tableView的数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ProductCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    // 1.取出模型
    SKProduct *product = self.products[indexPath.row];
    
    // 2.给cell设置数据
    cell.textLabel.text = product.localizedTitle;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"价格:%@", product.price];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取出模型
    SKProduct *product = self.products[indexPath.row];
    
    // 2.购买商品
    [self buyProduct:product];
}

#pragma mark - 购买商品
- (void)buyProduct:(SKProduct *)product
{
    // 1.创建票据
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    // 2.将票据加入到交易队列中
    [[SKPaymentQueue defaultQueue] addPayment:payment];
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
    for (SKPaymentTransaction *transation in transactions) {
        switch (transation.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"用户正在购买");
                break;
                
            case SKPaymentTransactionStatePurchased:
                NSLog(@"购买成功,将对应的商品给用户");
                
                // 将交易从交易队列中移除
                [queue finishTransaction:transation];
                break;
                
            case SKPaymentTransactionStateFailed:
                NSLog(@"购买失败,告诉用户没有付钱成功");
                
                // 将交易从交易队列中移除
                [queue finishTransaction:transation];
                break;
                
            case SKPaymentTransactionStateRestored:
                NSLog(@"恢复商品,将对应的商品给用户");
                // transation.payment.productIdentifier
                // 将交易从交易队列中移除
                [queue finishTransaction:transation];
                break;
                
            case SKPaymentTransactionStateDeferred:
                NSLog(@"未决定");
                break;
            default:
                break;
        }
    }
}

#pragma mark - 恢复购买
- (IBAction)restore:(id)sender {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
@end
