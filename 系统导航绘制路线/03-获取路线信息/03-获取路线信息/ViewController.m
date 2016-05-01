//
//  ViewController.m
//  03-获取路线信息
//
//  Created by apple on 14/11/2.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController ()

- (IBAction)startNavigation;
/**
 *  开始位置
 */
@property (weak, nonatomic) IBOutlet UITextField *startField;
/**
 *  结束位置
 */
@property (weak, nonatomic) IBOutlet UITextField *endField;
/**
 *  地理编码对象
 */
@property(nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation ViewController

/**
 *  点击开始导航按钮
 */
- (void)startNavigation
{
    // 1.获取用户输入的起点和终点
    NSString *startStr = self.startField.text;
    NSString *endStr = self.endField.text;
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
        
        
        // 3. 获取结束位置的地标
        [self.geocoder geocodeAddressString:endStr completionHandler:^(NSArray *placemarks, NSError *error) {
            
            if (placemarks.count == 0) return;
            
            // 结束位置的地标
            CLPlacemark *endCLPlacemark = [placemarks firstObject];
            
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
            
            NSArray *steps = route.steps;
            for (MKRouteStep *step in steps) {
                NSLog(@"%@ %f", step.instructions, step.distance);
            }
            
        }
    }];
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
