//
//  MainViewController.m
//  CSLeftSlideDemo
//
//  Created by LCS on 16/2/11.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "MainViewController.h"
#import "UIView+Extensions.h"
#import "UIBarButtonItem+Extensions.h"
#import "Constants.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"主界面";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:@"data" highLightImage:@"data" target:self action:@selector(onClickLeftItem)];
    
}

- (void)onClickLeftItem
{
    //发送通知，执行侧滑
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLeftSlide object:nil];
}

#pragma mark LeftViewControllerDelegate


@end
