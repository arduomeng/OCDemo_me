//
//  TestViewController.m
//  CSLeftSlideDemo
//
//  Created by LCS on 16/2/13.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "TestViewController.h"
#import "CSLeftSlideControllerOne.h"
#import "CSLeftSlideControllerTwo.h"
@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建主界面
    UIStoryboard *Storyboard1 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *mainVC = Storyboard1.instantiateInitialViewController;
    UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:mainVC];
    //创建左界面
    UIStoryboard *Storyboard2 = [UIStoryboard storyboardWithName:@"Left" bundle:nil];
    UIViewController *leftVC = Storyboard2.instantiateInitialViewController;
    
    /*侧滑效果一 初始化CSLeftSlideControllerOne*/
    
    CSLeftSlideControllerOne *LeftSlideController = [[CSLeftSlideControllerOne alloc] initWithLeftViewController:leftVC MainViewController:mainNav];
    [self addChildViewController:LeftSlideController];
    [self.view addSubview:LeftSlideController.view];
    
    /*侧滑效果二 初始化CSLeftSlideControllerTwo*/
    
//    CSLeftSlideControllerTwo *LeftSlideController = [[CSLeftSlideControllerTwo alloc] initWithLeftViewController:leftVC MainViewController:mainNav];
//    [self addChildViewController:LeftSlideController];
//    [self.view addSubview:LeftSlideController.view];
}

@end
