//
//  XMGBLEPeripheralViewController.m
//  03-BLE
//
//  Created by dyf on 15/9/30.
//  Copyright © 2015年 dyf. All rights reserved.
//

#import "XMGBLEPeripheralViewController.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "SVProgressHUD.h"

static NSString *const Service1StrUUID = @"FFF0";
static NSString *const notiyCharacteristicStrUUID = @"FFF1";
static NSString *const readwriteCharacteristicStrUUID = @"FFF2";
static NSString *const Service2StrUUID = @"FFE0";
static NSString *const readCharacteristicStrUUID = @"FFE1";
static NSString *const LocalNameKey = @"XMGPeripheral";

@interface XMGBLEPeripheralViewController () <CBPeripheralManagerDelegate>

@property (nonatomic, strong) CBPeripheralManager *pMgr; /**< 外设管理者 */

@property (nonatomic, strong) NSMutableArray *servieces; /**< 服务可变数组 */

@property (nonatomic, weak) NSTimer *timer; /**< 计时器 */

@end

@implementation XMGBLEPeripheralViewController

#pragma mark - 懒加载
// 外设管理者
- (CBPeripheralManager *)pMgr
{
    if (!_pMgr) {
        /*
         代理方法:
         必须实现的
         
         */
        _pMgr = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    }
    return _pMgr;
}
// 自定义服务
- (NSMutableArray *)servieces
{
    if (!_servieces) {
        _servieces = [NSMutableArray array];
    }
    return _servieces;
}


#pragma mark - 系统自带的方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 调用get方法初始化,初始化后调用代理方法peripheralManagerDidUpdateState:
    [self pMgr];
}

#pragma mark - CBPeripheralManagerDelegate
// CBPeripheralManager初始化后会触发的方法
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        // 提示设备成功打开
        [SVProgressHUD showSuccessWithStatus:@"xmg设备打开成功~"];
        // 配置各种服务入CBPeripheralManager
        [self yf_setupPMgr];
    }else
    {
        // 提示设备打开失败
        [SVProgressHUD showErrorWithStatus:@"失败!"];
    }
}

// 添加服务进CBPeripheralManager时会触发的方法
- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
{
    // 由于添加了两次ser,所以方法会调用两次
    static int i = 0;
    if (!error) {
        i++;
    }
    
    // 当第二次进入方法时候,代表两个服务添加完毕,此时
    if (i == self.servieces.count) {
        // 广播内容
        NSDictionary *advertDict = @{CBAdvertisementDataServiceUUIDsKey: [self.servieces valueForKeyPath:@"UUID"],
                                     CBAdvertisementDataLocalNameKey:LocalNameKey};
        // 发出广播,会触发peripheralManagerDidStartAdvertising:error:
        [peripheral startAdvertising:advertDict];
    }
}
// 开始广播触发的代理
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
}

// 外设收到读的请求,然后读特征的值赋值给request
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request
{
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
    // 判断是否可读
    if (request.characteristic.properties & CBCharacteristicPropertyRead) {
        NSData *data = request.characteristic.value;
        
        request.value = data;
        // 对请求成功做出响应
        [self.pMgr respondToRequest:request withResult:CBATTErrorSuccess];
    }else
    {
        [self.pMgr respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
    }
}
// 外设收到写的请求,然后读request的值,写给特征
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray<CBATTRequest *> *)requests
{
    NSLog(@"%s, line = %d, requests = %@", __FUNCTION__, __LINE__, requests);
    CBATTRequest *request = requests.firstObject;
    if (request.characteristic.properties & CBCharacteristicPropertyWrite) {
        NSData *data = request.value;
        // 此处赋值要转类型,否则报错
        CBMutableCharacteristic *mChar = (CBMutableCharacteristic *)request.characteristic;
        mChar.value = data;
        // 对请求成功做出响应
        [self.pMgr respondToRequest:request withResult:CBATTErrorSuccess];
    }else
    {
        [self.pMgr respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
    }
}


// 与CBCentral的交互
// 订阅特征
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"%s, line = %d, 订阅了%@的数据", __FUNCTION__, __LINE__, characteristic.UUID);
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                      target:self
                                                    selector:@selector(yf_sendData:)
                                                    userInfo:characteristic
                                                     repeats:YES];
    
    self.timer = timer;
    
    /* 另一种方法 */
//    NSTimer *testTimer = [NSTimer timerWithTimeInterval:2.0
//                                                 target:self
//                                               selector:@selector(yf_sendData:)
//                                               userInfo:characteristic
//                                                repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:testTimer forMode:NSDefaultRunLoopMode];
    
}
// 取消订阅特征
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"%s, line = %d, 取消订阅了%@的数据", __FUNCTION__, __LINE__, characteristic.UUID);
    [self.timer invalidate];
    self.timer = nil;
}

- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral
{
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
}


#pragma mark - 私有方法
- (void)yf_setupPMgr
{
    // 特征描述的UUID
    CBUUID *characteristicUserDescriptionUUID = [CBUUID UUIDWithString:CBUUIDCharacteristicUserDescriptionString];
    // 特征的通知UUID
    CBUUID *notifyCharacteristicUUID = [CBUUID UUIDWithString:notiyCharacteristicStrUUID];
    // 特征的读写UUID
    CBUUID *readwriteCharacteristicUUID = [CBUUID UUIDWithString:readwriteCharacteristicStrUUID];
    // 特征的只读UUID
    CBUUID *readCharacteristicUUID = [CBUUID UUIDWithString:readwriteCharacteristicStrUUID];
    CBUUID *ser1UUID = [CBUUID UUIDWithString:Service1StrUUID];
    CBUUID *ser2UUID = [CBUUID UUIDWithString:Service2StrUUID];
    
    
    // 初始化一个特征的描述
    CBMutableDescriptor *des1 = [[CBMutableDescriptor alloc] initWithType:characteristicUserDescriptionUUID value:@"xmgDes1"];
    
    // 可通知的特征
    CBMutableCharacteristic *notifyCharacteristic = [[CBMutableCharacteristic alloc] initWithType:notifyCharacteristicUUID // UUID
                                                                                       properties:CBCharacteristicPropertyNotify // 枚举:通知
                                                                                            value:nil // 数据先不传
                                                                                      permissions:CBAttributePermissionsReadable]; // 枚举:可读
    // 可读写的特征
    CBMutableCharacteristic *readwriteChar = [[CBMutableCharacteristic alloc] initWithType:readwriteCharacteristicUUID
                                                                                properties:CBCharacteristicPropertyRead | CBCharacteristicPropertyWrite
                                                                                     value:nil
                                                                               permissions:CBAttributePermissionsReadable | CBAttributePermissionsWriteable];
    [readwriteChar setDescriptors:@[des1]]; // 设置特征的描述
    
    // 只读特征
    CBMutableCharacteristic *readChar = [[CBMutableCharacteristic alloc] initWithType:readCharacteristicUUID
                                                                           properties:CBCharacteristicPropertyRead
                                                                                value:nil
                                                                          permissions:CBAttributePermissionsReadable];
    
    // 初始化服务1
    CBMutableService *ser1 = [[CBMutableService alloc] initWithType:ser1UUID primary:YES];
    // 为服务设置俩特征(通知, 带描述的读写)
    [ser1 setCharacteristics:@[notifyCharacteristic, readwriteChar]];
    [self.servieces addObject:ser1];
    
    // 初始化服务2,并且添加一个只读特征
    CBMutableService *ser2 = [[CBMutableService alloc] initWithType:ser2UUID primary:YES];
    ser2.characteristics = @[readChar];
    [self.servieces addObject:ser2];
    
    // 添加服务进外设管理者
    // 添加操作会触发代理方法peripheralManager:didAddService:error:
    if (self.servieces.count) {
        for (CBMutableService *ser in self.servieces) {
            [self.pMgr addService:ser];
        }
    }
}

// 计时器每隔两秒调用的方法
- (BOOL)yf_sendData:(NSTimer *)timer
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yy:MM:dd:HH:mm:ss";

    NSString *now = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"now = %@", now);
    
    // 执行回应central通知数据
    return  [self.pMgr updateValue:[now dataUsingEncoding:NSUTF8StringEncoding]
         forCharacteristic:timer.userInfo
      onSubscribedCentrals:nil];
}

@end
