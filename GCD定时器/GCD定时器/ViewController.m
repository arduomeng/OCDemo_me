//
//  ViewController.m
//  GCD定时器
//
//  Created by Apple on 16/4/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //GCD定时器不受RunLoop影响，更加精确
    
    static int count = 0;
    // 获得全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 创建一个定时器(dispatch_source_t是OC对象)
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 设置定时器启动时间，间隔时间
    dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), (int64_t)(1 * NSEC_PER_SEC), 0);
    // 设置定时器处理block或者函数
    dispatch_source_set_event_handler(_timer, ^{
        NSLog(@"----  %@  ---", [NSThread currentThread]);
        
        if (count++ == 4) {
            dispatch_cancel(_timer);
            _timer = nil;
        }
    });
    // 启动定时器
    dispatch_resume(_timer);
    
    /*
     *dispatch_after方法延时执行，实际上就是上面步骤的封装
     *dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(<#delayInSeconds#> * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     *<#code to be executed after a specified delay#>
     *});
     */
    
}

@end
