//
//  ViewController.m
//  本地推送通知
//
//  Created by Apple on 16/5/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 1. 创建本地通知
    UILocalNotification *local = [[UILocalNotification alloc] init];
    
    // 2. 设置通知
    local.fireDate = [NSDate dateWithTimeIntervalSinceNow:5.0];
    // 通知内容
    local.alertBody = @"xxx通知";
    // 滑动来xx
    local.alertAction = @"xx";
    // 点击通知显示启动图片，启动图片为应用启动图片无法修改
    local.alertLaunchImage = @"xxxxxx";
    // 通知音效，可以修改(UILocalNotificationDefaultSoundName ： 默认音效 )
    local.soundName = UILocalNotificationDefaultSoundName;
    
    
    // 设置userinfo传递信息
    local.userInfo = @{
                       @"type" : @1
                       };
    
    // 3.调用通知 (ios8 需要注册)
    [[UIApplication sharedApplication] scheduleLocalNotification:local];
    
}

@end
