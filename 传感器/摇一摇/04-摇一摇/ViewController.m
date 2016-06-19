//
//  ViewController.m
//  04-摇一摇
//
//  Created by xiaomage on 15/8/20.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"用户摇一摇");
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    // 摇一摇被打断(电话)
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    // 摇一摇结束
}

@end
