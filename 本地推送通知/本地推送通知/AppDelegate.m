//
//  AppDelegate.m
//  本地推送通知
//
//  Created by Apple on 16/5/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

// 进入应用程序的时候会调用该方法，不同的进入方式，launchOptions的值不同。根据这个可以判断是否是点击本地通知进入应用程序的
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 注册本地通知
    if([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0){
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    }
    
    // 针对点击通知时应用程序被杀死状态，重新启动后的跳转
    if (launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]){
        NSLog(@"执行程序跳转 通知信息在UIApplicationLaunchOptionsLocalNotificationKey对应的值中");
        application.applicationIconBadgeNumber -= 1;
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    // 针对点击通知时应用程序在后台的时候进行跳转 UIApplicationStateInactive : 程序从后台进入前台或者从前台进入后台
    if (application.applicationState == UIApplicationStateInactive) {
        application.applicationIconBadgeNumber -= 1;
        NSLog(@"执行程序跳转 通知信息 %@", notification);
    }
}

@end
