//
//  AppDelegate.m
//  UMengDemo
//
//  Created by LCS on 15/12/30.
//  Copyright (c) 2015年 LCS. All rights reserved.
//

#import "AppDelegate.h"
#import <UMSocial.h>
#import <UMSocialWechatHandler.h>
#import <UMSocialQQHandler.h>
#define KWeiChatAppID       @"wxc76cb164060c6a44"
#define KWeiChatAppScreet   @"758f3ecf5f7ae6713d8af7083751ef6b"
#define KQQAppkey           @"6i10FitKIn4pnFhF"
#define KQQAppID            @"1104912049"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UMSocialData setAppKey:@"5667985067e58ebac900547a"];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:KWeiChatAppID appSecret:KWeiChatAppScreet url:@"http://www.umeng.com/social"];
    
    [UMSocialQQHandler setQQWithAppId:KQQAppID appKey:KQQAppkey url:@"http://www.umeng.com/social"];
    
    return YES;
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}

@end
