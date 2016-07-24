# BLE-periphral外设模式流程

#### 之前在基础知识介绍过BLE应用的两种流程,如图:
![图4.1.1](./bleIma/ble_01.png)

- central模式用的都是左边的类，而peripheral模式用的是右边的类

## peripheral模式的流程

- 1.引入CoreBluetooth框架,初始化peripheralManager
- 2.设置peripheralManager中的内容
- 3.开启广播advertising
- 4.对central的操作进行响应
    - 4.1 读characteristics请求
    - 4.2 写characteristics请求
    - 4.4 订阅和取消订阅characteristics

## 准备环境
- Xcode
- 真机(4s以上)

## 具体操作步骤

#### 1.引入CoreBluetooth框架,初始化peripheralManager

```objc
#import <CoreBluetooth/CoreBluetooth.h>
@interface XMGBLEPeripheralViewController () <CBPeripheralManagerDelegate>
@property (nonatomic, strong) CBPeripheralManager *pMgr; /**< 外设管理者 */
@end

@implementation XMGBLEPeripheralViewController
// 懒加载
- (CBPeripheralManager *)pMgr
{
    if (!_pMgr) {
        _pMgr = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    }
    return _pMgr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 调用get方法初始化,初始化后CBPeripheralManager状态改变会调用代理方法peripheralManagerDidUpdateState:
    // 模拟器永远也不会是CBPeripheralManagerStatePoweredOn状态
    [self pMgr];
}
```

#### 2.设置peripheralManager中的内容
 - 创建characteristics及其description,
 - 创建service,把characteristics添加到service中,
 - 再把service添加到peripheralManager中

```objc
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

    // 初始化服务2,并且添加一个只读特征
    CBMutableService *ser2 = [[CBMutableService alloc] initWithType:ser2UUID primary:YES];
    ser2.characteristics = @[readChar];

    // 添加服务进外设管理者
    // 添加操作会触发代理方法peripheralManager:didAddService:error:
    [self.pMgr addService:ser1];
    [self.pMgr addService:ser2];
}
```

#### 3.开启广播

```objc
// 添加服务进CBPeripheralManager时会触发的方法
- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
{
    // 由于添加了两次ser,所以方法会调用两次
    static int i = 0;
    if (!error) {
        i++;
    }

    // 当第二次进入方法时候,代表两个服务添加完毕,此时要用到2,由于没有扩展性,所以新增了可变数组,记录添加的服务数量
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

}

>>>>>>>>分割线>>>>下面是修改的地方

@property (nonatomic, strong) NSMutableArray *servieces; /**< 服务可变数组 */
// 自定义服务
- (NSMutableArray *)servieces
{
    if (!_servieces) {
        _servieces = [NSMutableArray array];
    }
    return _servieces;
}
#pragma mark - 私有方法
- (void)yf_setupPMgr
{
    ...

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
```

#### 4.对central的操作做出响应
- 4.1 读characteristics请求
- 4.2 写characteristics请求
- 4.3 订阅和取消订阅characteristics

```objc
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
```
