//
//  CSTabBarController.m
//  导航栏和Tabbar
//
//  Created by LCS on 16/3/30.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "CSTabBarController.h"
#import "CSViewControllerOne.h"
#import "CSViewControllerTwo.h"
#import "CSNavController.h"
@interface CSTabBarController ()

@end

@implementation CSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpVC];
    
//    设置tabbar的颜色。包括图片和文字
//    self.tabBar.tintColor = [UIColor redColor];
}

- (void)setUpChildViewControllerWithVC:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    
    //设置tabbarItem.selectedImage需要设置UIImageRenderingModeAlwaysOriginal取消系统默认的蓝色效果
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    [self addChildViewController:vc];
}

- (void)setUpVC{
    
    CSViewControllerOne *ctrl1 = [[CSViewControllerOne alloc] init];
    CSNavController *nav1 = [[CSNavController alloc] initWithRootViewController:ctrl1];
    [self setUpChildViewControllerWithVC:nav1 title:@"首页" image:@"icon_property_nor" selectedImage:@"icon_property_pre"];
    
    CSViewControllerTwo *ctrl2 = [[CSViewControllerTwo alloc] init];
    [self setUpChildViewControllerWithVC:ctrl2 title:@"客户" image:@"icon_information_nor" selectedImage:@"icon_information_pre"];
}



@end
