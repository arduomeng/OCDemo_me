//
//  AppDelegate.m
//  MobVista
//
//  Created by arduomeng on 16/9/7.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import "AppDelegate.h"
#import <MVSDK/MVSDK.h>
#import "Constant.h"

#define APIKEY @"e708c4bd96e9ca808eeb2e53b41d3fef"
#define APPID  @"24637"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[MVSDK sharedInstance] setAppID:APPID ApiKey:APIKEY];
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    //预加载广告
    MVTemplate *template1 = [MVTemplate templateWithType:MVAD_TEMPLATE_BIG_IMAGE adsNum:1];
    //    MVTemplate *template2 = [MVTemplate templateWithType:MVAD_TEMPLATE_ONLY_ICON adsNum:10];
    NSArray *temArr = @[template1];

    [[MVSDK sharedInstance] preloadNativeAdsWithUnitId:MainUnitID fbPlacementId:nil supportedTemplates:temArr autoCacheImage:YES adCategory:0];
    
    //预加载应用墙
    [[MVSDK sharedInstance] preloadAppWallAdsWithUnitId:WallUnitID];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
