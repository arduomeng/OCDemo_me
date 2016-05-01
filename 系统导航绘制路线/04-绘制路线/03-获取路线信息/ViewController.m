//
//  ViewController.m
//  03-获取路线信息
//
//  Created by apple on 14/11/2.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "HMAnnotation.h"

@interface ViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapVIew;

/**
 *  地理编码对象
 */
@property(nonatomic, strong) CLGeocoder *geocoder;

- (IBAction)drawLine;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapVIew.delegate = self;
}

/**
 *  点击开始导航按钮
 */
- (IBAction)drawLine
{
    // 1.获取用户输入的起点和终点
    NSString *startStr = @"北京";
    NSString *endStr = @"云南";
    if (startStr == nil || startStr.length == 0 ||
        endStr == nil || endStr.length == 0) {
        NSLog(@"请输入起点或者终点");
        return;
    }
    
    // 2.利用GEO对象进行地理编码获取到地标对象(CLPlacemark )
    // 2.1获取开始位置的地标
    [self.geocoder geocodeAddressString:startStr completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count == 0) return;
        
        // 开始位置的地标
        CLPlacemark *startCLPlacemark = [placemarks firstObject];
        
        // 添加起点的大头针
        HMAnnotation *startAnno = [[HMAnnotation alloc ] init];
        startAnno.title = startCLPlacemark.locality;
        startAnno.subtitle = startCLPlacemark.name;
        startAnno.coordinate = startCLPlacemark.location.coordinate;
        [self.mapVIew addAnnotation:startAnno];
        
        // 3. 获取结束位置的地标
        [self.geocoder geocodeAddressString:endStr completionHandler:^(NSArray *placemarks, NSError *error) {
            
            if (placemarks.count == 0) return;
            
            // 结束位置的地标
            CLPlacemark *endCLPlacemark = [placemarks firstObject];
            
            // 添加终点的大头针
            HMAnnotation *endAnno = [[HMAnnotation alloc ] init];
            endAnno.title = endCLPlacemark.locality;
            endAnno.subtitle = endCLPlacemark.name;
            endAnno.coordinate = endCLPlacemark.location.coordinate;
            [self.mapVIew addAnnotation:endAnno];
            
            // 开始导航
            [self startDirectionsWithstartCLPlacemark:startCLPlacemark endCLPlacemark:endCLPlacemark];
        }];
        
    }];
}

/**
 *  发送请求获取路线相信信息
 *
 *  @param startCLPlacemark 起点的地标
 *  @param endCLPlacemark   终点的地标
 */
- (void)startDirectionsWithstartCLPlacemark:(CLPlacemark *)startCLPlacemark endCLPlacemark:(CLPlacemark *)endCLPlacemark
{

    /*
     MKDirectionsRequest:说清楚:从哪里 --> 到哪里
     MKDirectionsResponse:从哪里 --> 到哪里 :的具体路线信息
     */
    
    // -1.创建起点和终点对象
    // -1.1创建起点对象
    MKPlacemark *startMKPlacemark = [[MKPlacemark alloc] initWithPlacemark:startCLPlacemark];
    MKMapItem *startItem = [[MKMapItem alloc] initWithPlacemark:startMKPlacemark];
    
    // -1.2创建终点对象
    MKPlacemark *endMKPlacemark = [[MKPlacemark alloc] initWithPlacemark:endCLPlacemark];
    MKMapItem *endItem = [[MKMapItem alloc] initWithPlacemark:endMKPlacemark];
    
    
    // 0.创建request对象
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    // 0.1设置起点
    request.source = startItem;
    // 0.2设置终点
    request.destination = endItem;
    
    
    
    // 1.发送请求到苹果的服务器获取导航路线信息
    // 接收一个MKDirectionsRequest请求对象, 我们需要在该对象中说清楚:
    // 从哪里 --> 到哪里
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    // 2.计算路线信息, 计算完成之后会调用blcok
    // 在block中会传入一个响应者对象(response), 这个响应者对象中就存放着路线信息
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        
        // 打印获取到的路线信息
        // 2.1获取所有的路线
        NSArray *routes = response.routes;
        for (MKRoute *route in routes) {
            NSLog(@"%f千米 %f小时", route.distance / 1000, route.expectedTravelTime/ 3600);
            
            //  3.绘制路线(本质: 往地图上添加遮盖)
            // 传递当前路线的几何遮盖给地图, 地图就会根据遮盖自动绘制路线
            // 当系统开始绘制路线时会调用代理方法询问当前路线的宽度/颜色等信息
            [self.mapVIew addOverlay:route.polyline];
            
            NSArray *steps = route.steps;
            for (MKRouteStep *step in steps) {
//                NSLog(@"%@ %f", step.instructions, step.distance);
            }
            
        }
    }];
}

#pragma mark - MKMapViewDelegate

// 过时
//- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay

// 绘制路线时就会调用(添加遮盖时就会调用)
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
//    MKOverlayRenderer *renderer = [[MKOverlayRenderer alloc] init];
    // 创建一条路径遮盖
    NSLog(@"%s", __func__);
#warning 注意, 创建线条时候,一定要制定几何路线
    MKPolylineRenderer *line = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    line.lineWidth = 5; // 路线的宽度
    line.strokeColor = [UIColor redColor];// 路线的颜色
    
    // 返回路线
    return line;
}

#pragma mark - 懒加载
- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}



@end
