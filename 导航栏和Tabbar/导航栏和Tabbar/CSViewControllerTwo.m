//
//  CSViewControllerTwo.m
//  导航栏和Tabbar
//
//  Created by LCS on 16/3/30.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "CSViewControllerTwo.h"

@interface CSViewControllerTwo ()

@end

@implementation CSViewControllerTwo

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //viewDidAppear里面改变状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}


@end
