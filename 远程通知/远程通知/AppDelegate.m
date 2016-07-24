//
//  AppDelegate.m
//  远程通知
//
//  Created by Apple on 16/5/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


// 远程通知 系统会自动获取UUID和BundleID不需要手动获取

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        // ios 8
        // 注册setting
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeBadge | UIUserNotificationTypeAlert categories:nil];
        [application registerUserNotificationSettings:setting];
        
        // 注册远程通知
        [application registerForRemoteNotifications];
    }else{
        // ios 7
        // 注册远程通知
        UIRemoteNotificationType type = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeNewsstandContentAvailability;
        [application registerForRemoteNotificationTypes:type];
    }
    
    // 执行自定义操作(点击通知，程序启动时)
    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    // 将deviceToken发送给服务器
    NSLog(@"%@", deviceToken.description);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    // 执行自定义操作(点击通知，程序从后台到前台)
    if (application.applicationState == UIApplicationStateInactive) {
        
    }
}


// 开启后台模式，并且接受到的通知有content-available字段，则接收到通知后会调用该方法，在后台进行操作
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    // 执行自定义操作(不需要点击通知，收到通知就调用该方法)
    NSLog(@"执行自定义的操作，收到通知后调用，不需要点击通知");
    // 1.打开后台模式(Capabilities中的background mode)
    // 2.告诉系统是否有新内容的更新
    completionHandler(UIBackgroundFetchResultNewData);
    // 3.发送的通知有固定的格式
    /*
     一般通知格式 {"alert" : "xxx", "badge" : 1, "sound" : "xx"}
     想要让远程通知能在后台刷新必须添加键值对  "content-available" : "xx"
     */
}

@end
