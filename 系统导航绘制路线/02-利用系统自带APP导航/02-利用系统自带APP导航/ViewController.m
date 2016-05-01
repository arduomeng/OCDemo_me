//
//  ViewController.m
//  02-利用系统自带APP导航
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
            [self startNavigationWithstartCLPlacemark:startCLPlacemark endCLPlacemark:endCLPlacemark];
        }];
        
    }];
}

/**
 *  开始导航
 *
 *  @param startCLPlacemark 起点的地标
 *  @param endCLPlacemark   终点的地标
 */
- (void)startNavigationWithstartCLPlacemark:(CLPlacemark *)startCLPlacemark endCLPlacemark:(CLPlacemark *)endCLPlacemark
{

    // 0.创建起点和终点
    // 0.1创建起点
    MKPlacemark *startPlacemark = [[MKPlacemark alloc] initWithPlacemark:startCLPlacemark];
    MKMapItem *startItem = [[MKMapItem alloc] initWithPlacemark:startPlacemark];;
    
    // 0.2创建终点
    MKPlacemark *endPlacemark = [[MKPlacemark alloc] initWithPlacemark:endCLPlacemark];
    MKMapItem *endItem = [[MKMapItem alloc] initWithPlacemark:endPlacemark];
    
    // 1. 设置起点和终点数组
    NSArray *items = @[startItem, endItem];
    
    
    // 2.设置启动附加参数
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    // 导航模式(驾车/走路)
    md[MKLaunchOptionsDirectionsModeKey] = MKLaunchOptionsDirectionsModeDriving;
    // 地图显示模式
//    md[MKLaunchOptionsMapTypeKey] = @(MKMapTypeHybrid);
    
    
    // 只要调用MKMapItem的open方法, 就可以打开系统自带的地图APP进行导航
    // Items: 告诉系统地图APP要从哪到哪
    // launchOptions: 启动系统自带地图APP的附加参数(导航的模式/是否需要先交通状况/地图的模式/..)
    [MKMapItem openMapsWithItems:items launchOptions:md];
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
