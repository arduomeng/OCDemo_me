//
//  ViewController.m
//  内购-VideoShow
//
//  Created by arduomeng on 16/8/25.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import "ViewController.h"
#import "CSAPManager.h"
@interface ViewController () <CSAPManagerDelegate>

@property (nonatomic, strong) NSArray <SKProduct *>*dataArr;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 去自己的服务器请求所有想卖商品的ProductIds
    //    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"iapdemo.plist" ofType:nil];
    //    NSArray *productArray = [NSArray arrayWithContentsOfFile:filePath];
    //    NSArray *productIdArray = [productArray valueForKeyPath:@"productId"];
    
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
    NSArray *productIdArray = @[@"VideoShow_Product_id3",@"VideoShow_Product_id4",@"VideoShow_Product_id5",@"VideoShow_Product_id6"];
    
    // 去苹果服务器请求可卖的商品
    if ([[CSAPManager shareInstance] isCanMakePayments]) {
        [CSAPManager shareInstance].delegate = self;
        [[CSAPManager shareInstance] requestProductWithId:productIdArray];
    }else{
        NSLog(@"用户禁止应用内付费购买");
    }
    
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
    //[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 移除观察者
    //[[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

#pragma mark - 实现tableView的数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ProductCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    if (indexPath.row == self.dataArr.count) {
        cell.textLabel.text = @"恢复";
        return cell;
    }
    
    // 1.取出模型
    SKProduct *product = self.dataArr[indexPath.row];
    
    // 2.给cell设置数据
    /*
     价格格式化
     NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
     [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
     [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
     [numberFormatter setLocale:product.priceLocale];
     NSString *formattedPrice = [numberFormatter stringFromNumber:product.price];
     */
    cell.textLabel.text = product.localizedTitle;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"价格:%@ %@", product.price,product.localizedDescription];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataArr.count) {
        [[CSAPManager shareInstance] restorePurchase];
        return;
    }
    
    SKProduct *product = self.dataArr[indexPath.row];
    NSString *productIdent = product.productIdentifier;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:productIdent]) {
        NSLog(@"%@ 商品已经购买可以使用", product.localizedTitle);
    }else{
        [[CSAPManager shareInstance] purchaseProduct:self.dataArr[indexPath.row]];
    }
}
#pragma mark CSAPManagerDelegate
// 获取到商品列表
- (void)CSAPManagerDidReceiveProduct:(NSArray<SKProduct *> *)productArr{
    self.dataArr = productArr;
    
    [self.tableView reloadData];
}

// 购买成功
- (void)CSAPManagerCompletePurchaseWithProductid:(NSString *)productIdent{
    //如果是消耗品则记录购买数量，非消耗品则记录是否购买过
    // 保存购买记录
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:productIdent];
}

// 购买失败
- (void)CSAPManagerFailurePurchase{
    
}

// 恢复失败
-(void)failedRestoredPurchaseOfId:(NSString *)errorDescripiton {
    NSLog(@"恢复失败");
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:errorDescripiton delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
    [alertView show];
}

// 所有商品恢复成功
- (void)successRestoredPurchaseOfId : (SKPaymentQueue *)queue {
    
    /* VideoShow的做法 商品全部恢复成功后，再依次保存UserDefaults
    for (int i = 0; i<[queue.transactions count]; i++) {
        SKPaymentTransaction *transaction = [queue.transactions objectAtIndex:i];
        NSString *productIdentifier = transaction.originalTransaction.payment.productIdentifier;
        
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:productIdentifier];
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"restored", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alertView show];
    }
     */
}

- (void)CSAPManagerRestorePurchaseWithProductid:(NSString *)productIdent{
    // 保存恢复记录
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:productIdent];
}

- (void)filedWithErrorCode:(NSInteger)errorCode andError:(NSString *)error {
    switch (errorCode) {
        case IAP_FILEDCOED_APPLECODE:
        {
            NSLog(@"用户禁止应用内付费购买:%@",error);
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:error delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
            [alertView show];
        }
            break;
            
        case IAP_FILEDCOED_NORIGHT:
        {
            NSLog(@"用户禁止应用内付费购买");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unlock_privilege_2" ,nil) message:NSLocalizedString(@"Unlock_privilege_2", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
            [alertView show];
        }
            
            break;
            
        case IAP_FILEDCOED_EMPTYGOODS:
            NSLog(@"商品为空");
            break;
            
        case IAP_FILEDCOED_CANNOTGETINFORMATION:
            NSLog(@"无法获取产品信息，请重试");
            break;
            
        case IAP_FILEDCOED_BUYFILED:
            NSLog(@"购买失败，请重试");
            break;
            
        case IAP_FILEDCOED_USERCANCEL:
            NSLog(@"用户取消交易");
            break;
            
        default:
            break;
    }
}

@end
