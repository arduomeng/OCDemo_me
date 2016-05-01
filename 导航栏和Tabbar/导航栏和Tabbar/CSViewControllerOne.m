//
//  CSViewControllerOne.m
//  导航栏和Tabbar
//
//  Created by LCS on 16/3/30.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "CSViewControllerOne.h"

@interface CSViewControllerOne ()

@end

@implementation CSViewControllerOne
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.title = @"首页";
    
    UIView *temp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.view addSubview:temp];
    temp.backgroundColor = [UIColor redColor];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //viewDidAppear里面改变状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


@end
