//
//  ViewController.m
//  mapKit
//
//  Created by LCS on 16/6/3.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "CSAnnotation.h"
@interface ViewController () <CLLocationManagerDelegate,MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic, strong) CLLocationManager *mgr;
@property(nonatomic, strong) CLGeocoder *geocoder;
@end

@implementation ViewController

- (CLLocationManager *)mgr{
    if (!_mgr) {
        _mgr = [[CLLocationManager alloc] init];
        _mgr.desiredAccuracy = kCLLocationAccuracyBest;
        _mgr.delegate = self;
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
        // 主动要求用户对我们的程序授权, 授权状态改变就会通知代理
        [self.mgr requestAlwaysAuthorization]; // 请求前台和后台定位权限
    }
    
    /*
     MKMapTypeStandard = 0,
     MKMapTypeSatellite,
     MKMapTypeHybrid,
     MKMapTypeSatelliteFlyover NS_ENUM_AVAILABLE(10_11, 9_0),
     MKMapTypeHybridFlyover NS_ENUM_AVAILABLE(10_11, 9_0),
     */
    self.mapView.mapType = MKMapTypeStandard;
    //设置追终
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    
    NSLog(@"didUpdateUserLocation  %f, %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    
    //获取用户的经纬度并且显示在中间
    [self.mapView setCenterCoordinate:coordinate animated:YES];
    
    //设置显示区域
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.03);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    [self.mapView setRegion:region animated:YES];
    
    //反地理编码
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error || placemarks.count == 0) {
            return ;
        }
        CLPlacemark *pm = [placemarks firstObject];
        
        userLocation.title = pm.addressDictionary[@"State"];
        userLocation.subtitle = pm.name;
    }];
    
//    CSAnnotation *annotation = [[CSAnnotation alloc] init];
//    annotation.coordinate = coordinate;
//    annotation.title = business.name;
//    annotation.subtitle = deal.title;
//    annotation.icon = category.map_icon;
//    if ([self.mapView.annotations containsObject:annotation]) break;
//    //防止重复放置大头针，判断大头针是否存在
//    [self.mapView addAnnotation:annotation];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 获取点击的位置
    CGPoint point = [[touches anyObject] locationInView:self.mapView];
    
    // 将point转换成CLLocationCoordinate2D
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    
    // 添加大头针模型
    CSAnnotation *anno = [[CSAnnotation alloc] init];
    anno.coordinate = coordinate;
    //     反地理编码获取位置信息
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error || placemarks.count == 0) {
            return ;
        }
        CLPlacemark *pm = [placemarks firstObject];
        
        anno.title = pm.locality;
        anno.subtitle =  pm.thoroughfare;
        anno.icon = @"category_3";
        
        [self.mapView addAnnotation:anno];
    }];
    
    
    
}

// 当调用addAnootation添加大头针模型是，会调用该方法，创建大头针view
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(CSAnnotation *)annotation
{
    // 如果不实现或者返回nil则显示系统默认的大头针
    //大头针如果是当前位置的大头针则，只用系统自带的样式
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    static NSString *ID = @"deal";
    
    // 系统自带的大头针view(无法设置image，默认为系统的图片无法改变)
    /*
    MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (!pin) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
    }
    // 防止循环利用出现的问题，重新给view里面的annotation赋值
    pin.annotation = annotation;
    // 从天而降
    pin.animatesDrop = YES;
    // 是否显示标题
    pin.canShowCallout = YES;
    
    return pin;
     */
    
    // 自定义大头针view（可以改变image等属性）
    
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
        
        
    }
    //设置能够显示标题信息
    annotationView.canShowCallout = YES;
    //设置模型(位置／标题／自标题)
    annotationView.annotation = annotation;
    //设置图片
    annotationView.image = [UIImage imageNamed:annotation.icon];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    imageView.image = [UIImage imageNamed:@"huba"];
    annotationView.leftCalloutAccessoryView = imageView;
    // iOS 9.0
    annotationView.detailCalloutAccessoryView = [[UISwitch alloc] init];
    return annotationView;
}

// 滑动的时候回调
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    
    NSLog(@"%f -- %f", self.mapView.region.span.latitudeDelta, self.mapView.region.span.longitudeDelta);

}
// 取消选中大头针
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    
}

// 选中大头针
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
}

@end
