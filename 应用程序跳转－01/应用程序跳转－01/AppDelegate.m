//
//  AppDelegate.m
//  应用程序跳转－01
//
//  Created by LCS on 15/12/8.
//  Copyright (c) 2015年 LCS. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    NSLog(@"%@", url);
    
    return YES;
}

@end
