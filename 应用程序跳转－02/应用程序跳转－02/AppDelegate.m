//
//  AppDelegate.m
//  应用程序跳转－02
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
/**
 *  当被其他应用程序通过url打开时就会调用
 *
 *  @param application 当前应用程序
 *  @param url         打开当前程序的url
 *
 *  @return
 */
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    UINavigationController *nav = self.window.rootViewController;
    
    UIViewController *view = nav.topViewController;
    
    NSString *urlStr = [url absoluteString];
    
    NSString *scheme = nil;
    if ([urlStr hasPrefix:@"02://detail"]) {
//        //截取打开我们应用程序的scheme
//        
        NSRange range = [urlStr rangeOfString:@"myScheme"];
        
        if (range.length) {
            NSUInteger fromIndex = range.location + range.length + 1;
            scheme = [urlStr substringFromIndex:fromIndex];
            
            NSLog(@"appdelegate scheme %@", scheme);
        }
        
        
        NSLog(@"跳转到详情");
        [view performSegueWithIdentifier:@"detail" sender:scheme];
    }else if([urlStr hasPrefix:@"02://shouquan"]){
        
        NSRange range = [urlStr rangeOfString:@"myScheme"];
        
        if (range.length) {
            NSUInteger fromIndex = range.location + range.length +1;
            scheme = [urlStr substringFromIndex:fromIndex];
            
            NSLog(@"appdelegate scheme %@", scheme);
        }
        
        NSLog(@"跳转到授权");
        [view performSegueWithIdentifier:@"shouquan" sender:scheme];
    }
    
    return YES;
}

@end
