//
//  ViewController.m
//  RunLoop掌握
//
//  Created by LCS on 16/4/10.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self RunLoopTimer];
    
    [self RunLoopObserver];
}

//监听RunLoop的状态改变
- (void)RunLoopObserver{
    
    //kCFRunLoopAllActivities:监听RunLoop所有状态改变
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        NSLog(@"监听到RunLoop状态改变 －－－ %lu", activity);
    });
    //kCFRunLoopDefaultMode:给kCFRunLoopDefaultMode模式添加监听
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    
    //释放 observer
    CFRelease(observer);
}

- (void)RunLoopTimer{
    
    //等于下面两句的功能,只工作于DefaultRunLoopMode下
    //NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
    
    //定时器只工作于DefaultRunLoopMode下，当用户拖拽的时候定时器不工作
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    //定时器只工作于UITrackingRunLoopMode下，当用户拖拽的时候定时器工作
    NSTimer *timer2 = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(run2) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer2 forMode:UITrackingRunLoopMode];
    
    NSTimer *timer3 = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(run3) userInfo:nil repeats:YES];
    //定时器会运行在标记为CommonModes的模式下
    //标记为CommonModes的模式：UITrackingRunLoopMode和kCFRunLoopDefaultMode
    [[NSRunLoop mainRunLoop] addTimer:timer3 forMode:NSRunLoopCommonModes];
}

- (void)run{
    NSLog(@" NSDefaultRunLoopMode ");
}

- (void)run2{
    NSLog(@" UITrackingRunLoopMode ");
}

- (void)run3{
    NSLog(@" NSRunLoopCommonModes ");
}

@end
