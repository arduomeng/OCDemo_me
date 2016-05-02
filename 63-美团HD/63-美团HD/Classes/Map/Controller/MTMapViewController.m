//
//  MTMapViewController.m
//  63-美团HD
//
//  Created by LCS on 15/12/7.
//  Copyright (c) 2015年 Mac OS X. All rights reserved.
//

#import "MTMapViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "MTDeal.h"
#import "MTBusiness.h"
#import "MJExtension.h"
#import "MTDealAnnotation.h"
#import "MTCategory.h"
#import "MTMetaTool.h"
#import "MTHomeTopItem.h"
#import "MTCategoryViewController.h"
#import <MapKit/MapKit.h>
#import "DPAPI.h"
#import "MTConst.h"
@interface MTMapViewController ()<MKMapViewDelegate, DPRequestDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property(nonatomic, strong) CLLocationManager *mgr;
@property(nonatomic, strong) CLGeocoder *geocoder;
@property(nonatomic, copy) NSString *city;


/** 分类item */
@property (nonatomic, weak) UIBarButtonItem *categoryItem;

/** 分类popover */
@property (nonatomic, strong) UIPopoverController *categoryPopover;


/** 当前选中的分类名字 */
@property (nonatomic, copy) NSString *selectedCategoryName;

@property(nonatomic, strong) DPRequest *lastRequest;
@end

@implementation MTMapViewController

- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    // 左边的返回
    UIBarButtonItem *backItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"icon_back" highImage:@"icon_back_highlighted"];
    
    self.mapView.delegate = self;
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        //主动请求权限
        _mgr = [[CLLocationManager alloc] init];
        [_mgr requestAlwaysAuthorization];
        //配置info.plist
    }
    //设置能否旋转
    self.mapView.rotateEnabled = NO;
    //设置地图类型
    /*
     MKMapTypeStandard = 0,
     MKMapTypeSatellite,
     MKMapTypeHybrid
     */
    //设置追终
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    //设置左上角分类菜单
    MTHomeTopItem *categoryTopItem = [MTHomeTopItem item];
    [categoryTopItem addTarget:self action:@selector(categoryClick)];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:categoryTopItem];
    self.categoryItem = categoryItem;
    
    self.navigationItem.leftBarButtonItems = @[backItem, categoryItem];
    
    // 监听分类改变
    [MTNotificationCenter addObserver:self selector:@selector(categoryDidChange:) name:MTCategoryDidChangeNotification object:nil];
    
}

- (void)categoryClick
{
    // 显示分类菜单
    self.categoryPopover = [[UIPopoverController alloc] initWithContentViewController:[[MTCategoryViewController alloc] init]];
    [self.categoryPopover presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)categoryDidChange:(NSNotification *)notification
{
    MTCategory *category = notification.userInfo[MTSelectCategory];
    NSString *subcategoryName = notification.userInfo[MTSelectSubcategoryName];
    
    if (subcategoryName == nil || [subcategoryName isEqualToString:@"全部"]) { // 点击的数据没有子分类
        self.selectedCategoryName = category.name;
    } else {
        self.selectedCategoryName = subcategoryName;
    }
    if ([self.selectedCategoryName isEqualToString:@"全部分类"]) {
        self.selectedCategoryName = nil;
    }
    
    // 1.更换顶部item的文字
    MTHomeTopItem *topItem = (MTHomeTopItem *)self.categoryItem.customView;
    [topItem setIcon:category.icon highIcon:category.highlighted_icon];
    [topItem setTitle:category.name];
    [topItem setSubtitle:subcategoryName];
    
    // 2.关闭popover
    [self.categoryPopover dismissPopoverAnimated:YES];
    
    // 移除所有的大头针
    [self.mapView removeAnnotations:self.mapView.annotations];
    // 发送请求获取数据
    [self mapView:self.mapView regionDidChangeAnimated:YES];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark mapView代理方法
/**
 *  每次更新到用户的位置就会调用(只有位置改变才会调用)
 *
 *  @param mapView  控件
 *  @param userLocation     大头针模型
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    
    NSLog(@"didUpdateUserLocation  %f, %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    
    //获取用户的经纬度并且显示在中间
    [self.mapView setCenterCoordinate:coordinate animated:YES];
    
    //设置显示区域
    MKCoordinateSpan span = MKCoordinateSpanMake(0.5, 0.5);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    [self.mapView setRegion:region animated:YES];
//
    /*
     pm.locality, pm.addressDictionary
     
     先判断pm.locality若为空则说明是直辖市，pm.addressDictionary字典里的state
     */
    
    //反地理编码
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error || placemarks.count == 0) {
            return ;
        }
        CLPlacemark *pm = [placemarks firstObject];
        NSString *city = pm.locality ? pm.locality : pm.addressDictionary[@"State"];
        self.city = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
        
        //请求数据
        [self mapView:self.mapView regionDidChangeAnimated:YES];
    }];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (!self.city) {
        return;
    }
    
    CLLocationCoordinate2D coordinate = [self.mapView centerCoordinate];
    
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"city"] = self.city;
    params[@"latitude"] = @(coordinate.latitude);
    params[@"longitude"] = @(coordinate.longitude);
    params[@"radius"] = @(5000);
    
    if (self.selectedCategoryName) {
        params[@"category"] = self.selectedCategoryName;
    }
    
    self.lastRequest  = [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(MTDealAnnotation *)annotation
{
    //大头针如果是当前位置的大头针则，只用系统自带的样式
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    static NSString *ID = @"deal";
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
        //设置能够显示标题信息
        annotationView.canShowCallout = YES;
        
        
    }
    
    //设置模型(位置／标题／自标题)
    annotationView.annotation = annotation;
    
    //设置图片
    annotationView.image = [UIImage imageNamed:annotation.icon];
    return annotationView;
}

#pragma mark DPAPI代理
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    if (request != self.lastRequest) {
        return;
    }
}


- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    
    if (request != self.lastRequest) {
        return;
    }
    NSArray *deals = [MTDeal objectArrayWithKeyValuesArray:result[@"deals"]];
    
    for (MTDeal *deal in deals) {
        
        MTCategory *category = [MTMetaTool categoryWithDeal:deal];
        
        for (MTBusiness *business in deal.businesses) {
            
            MTDealAnnotation *annotation = [[MTDealAnnotation alloc] init];
            annotation.coordinate = CLLocationCoordinate2DMake(business.latitude, business.longitude);
            annotation.title = business.name;
            annotation.subtitle = deal.title;
            annotation.icon = category.map_icon;
            if ([self.mapView.annotations containsObject:annotation]) break;
            //防止重复放置大头针，判断大头针是否存在
            [self.mapView addAnnotation:annotation];
        }
    }
}


- (IBAction)onClickDingWeiButton:(id)sender {
    
}

@end
