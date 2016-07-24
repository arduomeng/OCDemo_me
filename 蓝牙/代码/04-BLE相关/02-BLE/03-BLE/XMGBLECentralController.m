//
//  XMGBLECentralController.m
//  03-BLE
//
//  Created by dyf on 15/9/30.
//  Copyright © 2015年 dyf. All rights reserved.
//

#import "XMGBLECentralController.h"
#import <CoreBluetooth/CoreBluetooth.h>

#import "SVProgressHUD.h"

@interface XMGBLECentralController () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *cMgr; /**< 中心管理设备 */

@property (nonatomic, strong) CBPeripheral *per; /**< 保存外设用 */

@end

@implementation XMGBLECentralController


#pragma mark - 懒加载
// 1.建立中心管理者
- (CBCentralManager *)cMgr
{
    if (!_cMgr) {
        NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
        /*
         设置主设备的代理,CBCentralManagerDelegate
         必须实现的：
         - (void)centralManagerDidUpdateState:(CBCentralManager *)central;//主设备状态改变调用的代理方法，在初始化CBCentralManager的适合会打开设备，只有当设备正确打开后才能使用
         其他选择实现的代理中比较重要的：
         - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI; //发现外设
         - (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral;//连接外设成功
         - (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;//外设连接失败
         - (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;//断开外设链接
         */
        _cMgr = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    }
    return _cMgr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"BLE";
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    //CBCharacteristicProperties
    
    // 初始化
    [self cMgr];
    
    // 不能在此处链接,因为状态还没改变
    //[self.cMgr scanForPeripheralsWithServices:nil options:nil];
}

#pragma mark - CBCentralManagerDelegate

// 中心管理者状态改变, 在初始化CBCentralManager的适合会打开设备，只有当设备正确打开后才能使用
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            NSLog(@">>>CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@">>>CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@">>>CBCentralManagerStateUnsupported");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@">>>CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@">>>CBCentralManagerStatePoweredOff");
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@">>>CBCentralManagerStatePoweredOn");
            // 2.开始扫描周围的外设
            /*
             第一个参数nil就是扫描周围所有的外设，扫描到外设后会进入
             - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;
             */
            [self.cMgr scanForPeripheralsWithServices:nil options:nil];
            
            break;
        default:
            break;
    }
}

// 扫描到设备会进入到此代理方法
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"%s, line = %d, per外设为 = %@, data = %@, rssi信号强度 = %@", __FUNCTION__, __LINE__, peripheral, advertisementData, RSSI);
    
    // 3.接下来可以连接设备
    //如果你没有设备，可以下载一个app叫lightbule的app去模拟一个设备
    //这里自己去设置下连接规则，我设置的是二维码扫描到的运动手环的设备号
    // 判断设备号是否扫描到
    if ([peripheral.name isEqualToString:@"OBand-75"] && (RSSI.integerValue > 30)) {
        /*
         一个主设备最多能连7个外设，每个外设最多只能给一个主设备连接,连接成功，失败，断开会进入各自的代理方法
         - (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral;//连接外设成功
         - (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;//外设连接失败
         - (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;//断开外设
         */
        // 保存外设,否则方法结束就销毁
        self.per = peripheral;
        [self.cMgr connectPeripheral:self.per options:nil];
    }else
    {
        // 此处Alert提示未扫描到设备,重新扫描
        NSLog(@"没扫描到 >>>>>>>>  %s, line = %d", __FUNCTION__, __LINE__);
        [SVProgressHUD showErrorWithStatus:@"没扫描到,请重新扫描"];
    }
}
// 外设连接成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
    NSLog(@">>>连接到名称为（%@）的设备-成功",peripheral.name);
    //设置的peripheral代理CBPeripheralDelegate
    //@interface ViewController : UIViewController<CBCentralManagerDelegate,CBPeripheralDelegate>
    [peripheral setDelegate:self];
    
    //扫描外设Services，成功后会进入方法：-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    [peripheral discoverServices:nil];
    /*
     Discovers the specified services of the peripheral.
     An array of CBUUID objects that you are interested in. Here, each CBUUID object represents a UUID that identifies the type of service you want to discover.
     */
}
// 外设连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
}
// 断开连接(丢失连接)
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
}


#pragma mark - CBPeripheralDelegate
// 发现外设的service
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error)
    {
        NSLog(@">>>Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
        return;
    }
    
    for (CBService *service in peripheral.services) {
        NSLog(@"service.UUID = %@", service.UUID);
        //扫描每个service的Characteristics，扫描到后会进入方法： -(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

// 外设发现service的特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error)
    {
        NSLog(@"error Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        return;
    }
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        NSLog(@"service:%@ 的 Characteristic: %@",service.UUID,characteristic.UUID);
    }
    
#warning noCodeFor 优化,分开写是为了让大家看注释清晰,并不符合编码规范
    //获取Characteristic的值，读到数据会进入方法：-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
    for (CBCharacteristic *characteristic in service.characteristics){
        [peripheral readValueForCharacteristic:characteristic]; // 外设读取特征的值
    }
    
    //搜索Characteristic的Descriptors，读到数据会进入方法：-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
    for (CBCharacteristic *characteristic in service.characteristics){
        [peripheral discoverDescriptorsForCharacteristic:characteristic]; // 外设发现特征的描述
    }
}

// 获取characteristic的值
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    //打印出characteristic的UUID和值
    //!注意，value的类型是NSData，具体开发时，会根据外设协议制定的方式去解析数据
    NSLog(@"%s, line = %d, characteristic.UUID:%@  value:%@", __FUNCTION__, __LINE__, characteristic.UUID, characteristic.value);
}
// 获取Characteristics的 descriptor的值
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(nonnull CBDescriptor *)descriptor error:(nullable NSError *)error
{
    //打印出DescriptorsUUID 和value
    //这个descriptor都是对于characteristic的描述，一般都是字符串，所以这里我们转换成字符串去解析
    NSLog(@"%s, line = %d, descriptor.UUID:%@ value:%@", __FUNCTION__, __LINE__, descriptor.UUID, descriptor.value);
}
// 发现特征Characteristics的描述Descriptor
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
    for (CBDescriptor *descriptor in characteristic.descriptors) {
        NSLog(@"descriptor.UUID:%@",descriptor.UUID);
    }
}

// 5.将数据写入特征(自定义方法,为了看的更清楚,没别的意思)
- (void)yf_peripheral:(CBPeripheral *)peripheral writeData:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic
{
    /*
     typedef NS_OPTIONS(NSUInteger, CBCharacteristicProperties) {
     CBCharacteristicPropertyBroadcast												= 0x01,
     CBCharacteristicPropertyRead													= 0x02,
     CBCharacteristicPropertyWriteWithoutResponse									= 0x04,
     CBCharacteristicPropertyWrite													= 0x08,
     CBCharacteristicPropertyNotify													= 0x10,
     CBCharacteristicPropertyIndicate												= 0x20,
     CBCharacteristicPropertyAuthenticatedSignedWrites								= 0x40,
     CBCharacteristicPropertyExtendedProperties										= 0x80,
     CBCharacteristicPropertyNotifyEncryptionRequired NS_ENUM_AVAILABLE(NA, 6_0)		= 0x100,
     CBCharacteristicPropertyIndicateEncryptionRequired NS_ENUM_AVAILABLE(NA, 6_0)	= 0x200
     };
     打印出特征的权限(characteristic.properties),可以看到有很多种,这是一个NS_OPTIONS的枚举,可以是多个值
     常见的又read,write,noitfy,indicate.知道这几个基本够用了,前俩是读写权限,后俩都是通知,俩不同的通知方式
     */
    NSLog(@"%s, line = %d, characteristic.properties:%lu", __FUNCTION__, __LINE__, (unsigned long)characteristic.properties);
    
    // 只有特征的properties中有写的属性时候,才写
    if (characteristic.properties & CBCharacteristicPropertyWrite) {
        // 这句才是正宗的核心代码
        [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
}

// 6.订阅特征的通知
// 设置通知
- (void)yf_peripheral:(CBPeripheral *)peripheral setNotifyForCharacteristic:(CBCharacteristic *)characteristic
{
    // 设置通知, 数据会进入 peripheral:didUpdateValueForCharacteristic:error:方法
    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
}
// 取消通知
- (void)yf_peripheral:(CBPeripheral *)peripheral cancelNotifyForCharacteristic:(CBCharacteristic *)characteristic
{
    [peripheral setNotifyValue:NO forCharacteristic:characteristic];
}

// 7.断开连接
- (void)yf_cMgr:(CBCentralManager *)cMgr stopScanAndDisConnectWithPeripheral:(CBPeripheral *)peripheral
{
    // 停止扫描
    [cMgr stopScan];
    // 断开连接
    [cMgr cancelPeripheralConnection:peripheral];
}

@end
