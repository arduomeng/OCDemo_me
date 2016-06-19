//
//  ViewController.m
//  硬件信息获取
//
//  Created by xiaomage on 15/8/19.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "UIDevice--Hardware.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.获取手机型号
    NSLog(@"手机型号:%@", [[UIDevice currentDevice] platformString]);
    
    // 2.获取剩余空间和一共多少空间
    NSLog(@"%@--%@", [[UIDevice currentDevice] freeDiskSpace], [[UIDevice currentDevice] totalDiskSpace]);
}

@end
