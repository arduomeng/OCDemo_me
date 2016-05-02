//
//  AppDelegate.m
//  XGPush
//
//  Created by LCS on 15/12/31.
//  Copyright (c) 2015年 LCS. All rights reserved.
//

#import "AppDelegate.h"
#import <XGPush.h>

#define kXGAppID            2200167136
#define kXGAppKey           @"IV96H48JWZ8S"
#define _IPHONE80_ 80000
@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)setupXG:(NSDictionary *)launchOptions appId:(uint32_t)appId appKey:(NSString *)appKey {
    
    [XGPush startApp:appId appKey:appKey];
    
    //  初始化账号，如果没有登录,先不注册
    [self setupAccount];
    
    //推送反馈回调版本示例
    void (^successBlock)(void) = ^(void){
        //NSLog(@"[XGPush]handleLaunching's successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //NSLog(@"[XGPush]handleLaunching's errorBlock");
    };
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];
}

- (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

- (void)setupAccount
{
    void (^successCallback)(void) = ^(void){
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
            //iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
            if(sysVer < 8){
                [self registerPush];
            }else{
                [self registerPushForIOS8];
            }
#else
            [self registerPush];
#endif
        }
    };
    [XGPush initForReregister:successCallback];
}


- (void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupXG:launchOptions appId:kXGAppID appKey:kXGAppKey];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    void (^successBlock)(void) = ^(void){
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"flag2"];
        NSLog(@"[XGPush]register successBlock");
    };
    void (^errorBlock)(void) = ^(void){
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"flag2"];
        NSLog(@"[XGPush]register errorBlock");
    };
    
    //注册设备
    NSString *deviceTokenStr = [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    
    //打印获取的deviceToken的字符串
    NSLog(@"deviceTokenStr is %@",deviceTokenStr);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"error %@", error);
}


@end
