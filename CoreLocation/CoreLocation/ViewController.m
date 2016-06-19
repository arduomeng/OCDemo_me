//
//  ViewController.m
//  CoreLocation
//
//  Created by LCS on 16/6/2.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

/*
 01-掌握-CoreLocation框架的基本使用—定位（iOS8.0-）
 》iOS8.0- 的定位实现
 》设置授权说明（段子写得好，用户授权的概率大）info.plist 中添加配置privary - Location Usage Description
 》设置位置更新的距离过滤（防止过于频繁的调用代理方法）
 》设置定位精度（精度越高，耗电越快。所以要根据需求选择合适的定位精度）
 》后台定位（勾选后台模式：location update）
 
 
 02-掌握-CoreLocation框架的基本使用—定位（iOS8.0+适配）
 》iOS8.0+授权适配（两种适配方案：通过系统版本号systemVersion，通过对象是否响应方法mgr respondsToSelector(requestAlwaysAuthorization)）
 配置info.list文件中对应的键值requestWhenInUseAuthorization和 requestAlwaysAuthorization
 》requestWhenInUseAuthorization 和 requestAlwaysAuthorization 区别（前者只有在APP前台时可以定位(如果勾选了后台定位，则也可以进行定位，但是顶部会出现蓝条显示该应用正在使用定位服务)，后者可以在前后台进行定位）
 》授权状态的变更，调用对应的代理方法（说明不同状态代表的含义，给予用户对应的提示）
 》演示前后台授权和前台授权同时请求时会发生什么情况，并解释原因。
 
 
 03-了解-CoreLocation框架的基本使用—定位（iOS9.0补充）
 》requestWhenInUseAuthorization 和 requestAlwaysAuthorization 区别（前者只有在APP前台时可以定位(如果勾选了后台定位，则默认不能进行定位.需要设置mgr.allowsBackgroundLocationUpdates ＝ yes 也可以进行定位，但是顶部会出现蓝条显示该应用正在使用定位服务)，后者可以在前后台进行定位）
 
 */

@interface ViewController () <CLLocationManagerDelegate>
/**
 *  定位管理者
 */
@property (nonatomic ,strong) CLLocationManager *mgr;

// 地理反地理编码
@property (nonatomic, strong) CLGeocoder *geocoder;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *latitude;
@property (weak, nonatomic) IBOutlet UITextField *longitude;

@end

@implementation ViewController

- (CLLocationManager *)mgr{
    if (!_mgr) {
        _mgr = [[CLLocationManager alloc] init];
        _mgr.delegate = self;
        // 定位的距离 100m 每隔多远定位一次
        //_mgr.distanceFilter = 100;
        // 精确度
        // _mgr.desiredAccuracy = kCLLocationAccuracyBest;
        // 获取方法，每隔多少度更新一次
        // _mgr.headingFilter = 2;
        
    }
    return _mgr;
}

- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.创建CoreLocation管理者
    
    // 2.判断是否是iOS8
    if([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
    {
        NSLog(@"%f", [[UIDevice currentDevice].systemVersion doubleValue]);
        // 主动要求用户对我们的程序授权, 授权状态改变就会通知代理
        [self.mgr requestAlwaysAuthorization]; // 请求前台和后台定位权限
        
        // 默认情况下只能在前台定位，勾选后台模式后能定位，但是会出现蓝条
        [self.mgr requestWhenInUseAuthorization];// 请求前台定位授权
    }else
    {
        NSLog(@"是iOS7");
        // 3.开始监听(开始获取位置)
        [self.mgr startUpdatingLocation];
    }
    
    // 3.开始获取用户方向
    // 注意:获取用户的方向信息是不需要用户授权的
    [self.mgr startUpdatingHeading];
    
    // 4.区域监听
    // 创建中心点
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(40.058501, 116.304171);
    
    // c创建圆形区域, 指定区域中心点的经纬度, 以及半径
    CLCircularRegion *circular = [[CLCircularRegion alloc] initWithCenter:center radius:500 identifier:@"HH"];
    
    [self.mgr startMonitoringForRegion:circular];
    
    // 5.主动监听某区域
    [_mgr requestStateForRegion:circular];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"等待用户授权");
    }else if (status == kCLAuthorizationStatusAuthorizedAlways){
        NSLog(@"前后台模式授权成功");
        // 开始定位
        [self.mgr startUpdatingLocation];
        
    }else{
        NSLog(@"授权失败");
        if ([CLLocationManager locationServicesEnabled]) {
            NSLog(@"定位开启，但是被拒");
        }else{
            NSLog(@"定位服务关闭");
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
    NSLog(@"location : %@", location);
    NSLog(@"%f , %f", location.coordinate.latitude, location.coordinate.longitude);
    
    /*
     》coordinate	（当前位置所在的经纬度）
     》altitude	（海拔）上海市
     》speed	（当前速度）
     course   (角度0-359.9)
     
     计算两次的距离(单位时米)
     CLLocationDistance distance = [newLocation distanceFromLocation:self.previousLocation];
     计算两次之间的时间（单位只秒）
     NSTimeInterval dTime = [newLocation.timestamp timeIntervalSinceDate:self.previousLocation.timestamp];
     计算速度（米／秒）
     CGFloat speed = distance / dTime;
     
     */
    
    
    // 关闭定位
    [_mgr stopUpdatingLocation];
}

// 当获取到用户方向时就会调用
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    /*
     magneticHeading 设备与磁北的相对角度
     trueHeading 设置与真北的相对角度, 必须和定位一起使用, iOS需要设置的位置来计算真北
     真北始终指向地理北极点
     */
    
    // 1.将获取到的角度转为弧度 = (角度 * π) / 180;
    CGFloat angle = newHeading.magneticHeading * M_PI / 180;
    NSLog(@"%f", angle);
    [_mgr stopUpdatingHeading];
}

// 进入监听区域时调用
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"进入监听区域时调用");
}
// 离开监听区域时调用
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"离开监听区域时调用");
}
// requestStateForRegion  主动监听区域结果
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSLog(@"主动区域监听结果 %ld", state);
}


- (IBAction)geocoderOnClick:(id)sender {
    
    // 1.创建地理编码对象
    
    // 2.利用地理编码对象编码
    // 根据传入的地址获取该地址对应的经纬度信息
    NSString *address = self.textView.text;
    if (![address length]) {
        return;
    }
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count == 0 || error != nil) {
            return ;
        }
        
        // placemarks地标数组, 地标数组中存放着地标, 每一个地标包含了该位置的经纬度以及城市/区域/国家代码/邮编等等...
        // 获取数组中的第一个地标
        CLPlacemark *placemark = [placemarks firstObject];
        /*
         位置
         CLLocation *location
         区域
         CLRegion *region
         字典
         NSDictionary *addressDictionary;
         地址
         NSString *name
         城市
         NSString *locality
         */
        self.latitude.text = [NSString stringWithFormat:@"%f", placemark.location.coordinate.latitude];
        self.longitude.text = [NSString stringWithFormat:@"%f", placemark.location.coordinate.longitude];
        // 地址：河北省廊坊市
        self.textView.text = placemark.name;
        
        // 详细地址 中国河北省廊坊市
//        NSArray *address = placemark.addressDictionary[@"FormattedAddressLines"];
//        NSMutableString *strM = [NSMutableString string];
//        for (NSString *str in address) {
//            [strM appendString:str];
//        }
//        self.textView.text = strM;
    }];
}
- (IBAction)disGeocoderOnClick:(id)sender {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[self.latitude.text doubleValue] longitude:[self.longitude.text doubleValue]];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count == 0 || error != nil) {
            return ;
        }
        
        // placemarks地标数组, 地标数组中存放着地标, 每一个地标包含了该位置的经纬度以及城市/区域/国家代码/邮编等等...
        // 获取数组中的第一个地标
        CLPlacemark *placemark = [placemarks firstObject];
        /*
         CLLocation *location
         CLRegion *region
         NSDictionary *addressDictionary;
         NSString *name
         */
        
        
        /*
         上海市 ： 31.2317  121.4726
         廊坊市 ： 39.5239  116.7044
         */
        self.latitude.text = [NSString stringWithFormat:@"%f", placemark.location.coordinate.latitude];
        self.longitude.text = [NSString stringWithFormat:@"%f", placemark.location.coordinate.longitude];
        self.textView.text = placemark.name;
        //中国河北省廊坊市广阳区解放道街道永丰道40号
        NSLog(@"%@", placemark.name);
        //河北省
        NSLog(@"%@", placemark.addressDictionary[@"State"]);
        //廊坊市
        NSLog(@"%@", placemark.locality);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
