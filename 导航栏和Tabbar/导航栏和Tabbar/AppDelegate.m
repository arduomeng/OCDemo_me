//
//  AppDelegate.m
//  导航栏和Tabbar
//
//  Created by LCS on 16/3/30.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "AppDelegate.h"
#import "CSTabBarController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] init];
    
    CSTabBarController *ctrl =  [[CSTabBarController alloc] init];
    
    self.window.rootViewController = ctrl;
    
    [self.window makeKeyAndVisible];
    
    //全局设置状态栏 info.plist 添加View controller-based status bar appearance
    
    //初始化导航栏
    [self setUpNav];
    
    //初始化Tabbar
    [self setUpTabBar];
    
    return YES;
}

- (void)setUpNav{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        //设置页面上的组件紧挨着导航栏，而不是从屏幕顶部开始显示(貌似这里并没有影响)
        [[UINavigationBar appearance] setTranslucent:NO];
    }
    

//设置navigationItem颜色(若设置了[UIBarButtonItem appearance] setTitleTextAttributes 则该设置无效)
    [[UINavigationBar appearance] setTintColor:[UIColor redColor]];
        
//设置导航栏颜色（若设置了setBackgroundImage， 则该设置无效）
//[[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
//设置导航栏的背景颜色
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"bg_detail_info"] forBarMetrics:UIBarMetricsDefault];
        
    //设置导航栏标题属性
    NSMutableDictionary *titleTextAttrs = [NSMutableDictionary dictionary];
    titleTextAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    titleTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    [[UINavigationBar appearance] setTitleTextAttributes:titleTextAttrs];
    
    //初始化UIBarButtonItem
    
    // 设置普通状态
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置不可用状态
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    disableTextAttrs[NSFontAttributeName] = textAttrs[NSFontAttributeName];
    [[UIBarButtonItem appearance] setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
    
}

- (void)setUpTabBar{
    
    UITabBarItem *item = [UITabBarItem appearance];
    
    //设置文字颜色
    NSMutableDictionary *dicNormal = [NSMutableDictionary dictionary];
    dicNormal[NSForegroundColorAttributeName] = [UIColor redColor];
    [item setTitleTextAttributes:dicNormal forState:UIControlStateNormal];
    NSMutableDictionary *dicSelected = [NSMutableDictionary dictionary];
    dicSelected[NSForegroundColorAttributeName] = [UIColor blueColor];
    [item setTitleTextAttributes:dicSelected forState:UIControlStateSelected];
}

@end
