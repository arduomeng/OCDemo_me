//
//  ViewController.m
//  10-自定义大头针(最基本)
//
//  Created by apple on 14/11/1.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "HMAnnotation.h"
#import "HMAnnotationView.h"

@interface ViewController ()<MKMapViewDelegate>
/**
 *  地图
 */
@property (weak, nonatomic) IBOutlet MKMapView *customMapView;

@property (nonatomic, strong) CLLocationManager *mgr;
/**
 *  地理编码对象
 */
@property (nonatomic ,strong) CLGeocoder *geocoder;
- (IBAction)addAnno;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 注意:在iOS8中, 如果想要追踪用户的位置, 必须自己主动请求隐私权限
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        // 主动请求权限
        self.mgr = [[CLLocationManager alloc] init];
        
        [self.mgr requestAlwaysAuthorization];
    }
    
    // 设置不允许地图旋转
    self.customMapView.rotateEnabled = NO;
    
    // 成为mapVIew的代理
    self.customMapView.delegate = self;
    
    // 如果想利用MapKit获取用户的位置, 可以追踪
    self.customMapView.userTrackingMode =  MKUserTrackingModeFollow;
    

}


#pragma MKMapViewDelegate
/**
 *  每次添加大头针就会调用(地图上有几个大头针就调用几次)
 *
 *  @param mapView    地图
 *  @param annotation 大头针模型
 *
 *  @return 大头针的view
 */
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
//    NSLog(@"%s", __func__);
    NSLog(@"annotation === %@", annotation);
    // 对用户当前的位置的大头针特殊处理
    if ([annotation isKindOfClass:[HMAnnotation class]] == NO) {
        return nil;
    }
    
    // 注意: 如果返回nil, 系统会按照自己默认的方式显示
//    return nil;
    
    /*
    static NSString *identifier = @"anno";
    // 1.从缓存池中取
    // 注意: 默认情况下MKAnnotationView是无法显示的, 如果想自定义大头针可以使用MKAnnotationView的子类MKPinAnnotationView
    
    // 注意: 如果是自定义的大头针, 默认情况点击大头针之后是不会显示标题的, 需要我们自己手动设置显示
//    MKPinAnnotationView *annoView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    // 2.如果缓存池中没有, 创建一个新的
    if (annoView == nil) {
//        annoView = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:identifier];
        annoView = [[MKAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:identifier];
        
        // 设置大头针的颜色
//        annoView.pinColor = MKPinAnnotationColorPurple;
        
        // 设置大头针从天而降
//        annoView.animatesDrop = YES;
        
        // 设置大头针标题是否显示
        annoView.canShowCallout = YES;
        
        // 设置大头针标题显示的偏移位
//        annoView.calloutOffset = CGPointMake(-50, 0);
        
        // 设置大头针左边的辅助视图
        annoView.leftCalloutAccessoryView = [[UISwitch alloc] init];
        // 设置大头针右边的辅助视图
        annoView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
      
    }
    
    // 设置大头针的图片
    // 注意: 如果你是使用的MKPinAnnotationView创建的自定义大头针, 那么设置图片无效, 因为系统内部会做一些操作, 覆盖掉我们自己的设置
//    annoView.image = [UIImage imageNamed:@"category_4"];
    HMAnnotation *anno = (HMAnnotation *)annotation;
    annoView.image = [UIImage imageNamed:anno.icon];
    
    // 3.给大头针View设置数据
    annoView.annotation = annotation;
    
    // 4.返回大头针View
    return annoView;
     */
    
    // 1.创建大头针
    HMAnnotationView *annoView = [HMAnnotationView annotationViewWithMap:mapView];
    // 2.设置模型
    annoView.annotation = annotation;
    
    // 3.返回大头针
    return annoView;
}

/**
 *  每次更新到用户的位置就会调用(调用不频繁, 只有位置改变才会调用)
 *
 *  @param mapView      促发事件的控件
 *  @param userLocation 大头针模型
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{

    // 利用反地理编码获取位置之后设置标题
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        NSLog(@"获取地理位置成功 name = %@ locality = %@", placemark.name, placemark.locality);
        userLocation.title = placemark.name;
        userLocation.subtitle = placemark.locality;
    }];
    
    /*
    // 设置地图显示的区域
    // 获取用户的位置
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    // 指定经纬度的跨度
    MKCoordinateSpan span = MKCoordinateSpanMake(5 ,5);
    // 将用户当前的位置作为显示区域的中心点, 并且指定需要显示的跨度范围
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    
    // 设置显示区域
    [self.customMapView setRegion:region animated:YES];
     */
    
    [self.customMapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
}
#pragma mark - 懒加载
- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (IBAction)addAnno {
    // 创建大头针模型
    HMAnnotation *anno = [[HMAnnotation alloc] init];
    anno.title = @"传智";
    anno.subtitle = @"育新小区";
    CGFloat latitude = 36.821199 + arc4random_uniform(20);
    CGFloat longitude = 116.858776 + arc4random_uniform(20);
    anno.coordinate = CLLocationCoordinate2DMake(latitude , longitude);
    anno.icon = @"category_1";
    
    // 添加大头针
    [self.customMapView addAnnotation:anno];
    
    
    // 创建大头针模型
    HMAnnotation *anno2 = [[HMAnnotation alloc] init];
    anno2.title = @"传智2";
    anno2.subtitle = @"育新小区2";
    CGFloat latitude2 = 36.821199 + arc4random_uniform(20);
    CGFloat longitude2 = 116.858776 + arc4random_uniform(20);
    anno2.coordinate = CLLocationCoordinate2DMake(latitude2 , longitude2);
    anno2.icon = @"category_2";
    
    // 添加大头针
    [self.customMapView addAnnotation:anno2];
}
@end
