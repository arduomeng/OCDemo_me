//
//  ViewController.m
//  05-集成百度地图
//
//  Created by apple on 14/11/2.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "ViewController.h"
#import "BMapKit.h"
/*
 libbaidumapapi.a静态库==百度以及实现好的功能
 注意: 静态库是区分真机和模拟器的, 如果在真机上使用模拟器的静态库是不可以运行的
 
 1.> "_SCNetworkReachabilityCreateWithName", referenced from:
 代表静态库中依赖的一些框架没有导入.如果静态库中用到了框架就必须导入
 
 2.> "std::terminate()", referenced from:
 但凡看到错误提示中提示两个冒号C++代码, 默认情况下Xcode创建的工程是不支持C++.
 如何解决: 将工程中任意一个文件的后缀改为.MM即可
 
 .c  C代码
 .cpp C++代码
 .m  C代码 + OC代码
 .MM C代码 + OC代码 + C++代码
 
 3.>Undefined symbols for architecture x86_64:
 以后但凡看到这个错误, 一般是指用到的三方框架不支持64位手机
 
 
 4.>注意:如果使用的Xcode6创建的工程, 想要成功的集成百度地图,还需要手动的添加一个Bundle display name
 */

@interface ViewController ()<BMKMapViewDelegate, BMKPoiSearchDelegate>
/**
 *  百度地图
 */
@property (nonatomic, strong) BMKMapView* mapView;
/**
 *  检索对象
 */
@property (nonatomic, strong) BMKPoiSearch *poisearch;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:mapView];
    self.mapView = mapView;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    btn.center = CGPointMake(200, 200);
    [self.view addSubview:btn];
    
}

- (void)btnClick
{
    // 检索周边的信息
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    // 检索的页码
    citySearchOption.pageIndex = 0;
    // 检索的条数
    citySearchOption.pageCapacity = 10;
    citySearchOption.city= @"北京";
    citySearchOption.keyword = @"桑拿";
    BOOL flag = [self.poisearch poiSearchInCity:citySearchOption];

    if(flag)
    {
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        NSLog(@"城市内检索发送失败");
    }
    
}
#pragma mark -
#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            [_mapView addAnnotation:item];
            if(i == 0)
            {
                //将第一个点的坐标移到屏幕中央
                _mapView.centerCoordinate = poi.pt;
            }
        }
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

#pragma makr - poisearch
- (BMKPoiSearch *)poisearch
{
    if (!_poisearch) {
        _poisearch = [[BMKPoiSearch alloc] init];
        _poisearch.delegate = self;
    }
    return _poisearch;
}

@end
