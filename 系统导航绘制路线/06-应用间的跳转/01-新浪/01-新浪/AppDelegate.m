//
//  AppDelegate.m
//  01-新浪
//
//  Created by apple on 14/11/2.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

/**
 *  当被其他应用程序通过URL打开时就会调用
 *
 *  @param application 当前的应用程序
 *  @param url         打开当前程序的URL
 *
 *  @return 是否成功处理
 */
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    // 1.获取首页控制器
    UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
    UIViewController *vc = nav.topViewController;
    
    NSLog(@"%@", url);
    // 判断是通过哪一个URL打开的, 做出相应的处理(跳转到相应的控制器)
    NSString *urlStr = url.absoluteString;
    if ([urlStr hasPrefix:@"sina://login"]) {
        
        // 截取打开我们程序的应用的scheme
        NSRange range = [urlStr rangeOfString:@"sina://login?myScheme="];
        NSString *scheme = [urlStr substringFromIndex:range.length];
        
        NSLog(@"跳转到授权界面 %@", scheme);
//        if ([vc isKindOfClass:[ViewController class]] == YES) {
            [vc performSegueWithIdentifier:@"home2accounts" sender:scheme];
//        }
        
    }else if ([urlStr hasPrefix:@"sina://view?id="])
    {
        NSLog(@"跳转到详情界面");
        [vc performSegueWithIdentifier:@"home2detail" sender:nil];
        
    }
    
    return YES;
}

/**
 *  当被其他应用程序通过URL打开时就会调用(新方法)
 *
 *  @param application       当前的应用程序
 *  @param url               打开当前程序的URL
 *  @param sourceApplication 打开当前程序的Bundle identifier
 *  @param annotation
 *
 *  @return 是否成功处理
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
#warning 注意: 如果实现了新方法, 旧方法旧失效了
    /*
     sourceApplication用途:
     当我们做一些广告, 积分墙等推广的时候, 可以利用这个唯一表一记录当前程序是被哪一个程序推广打开的
    */
    NSLog(@"%@ %@", url, sourceApplication);
    // 1.获取首页控制器
    UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
    UIViewController *vc = nav.topViewController;
    
    NSLog(@"%@", url);
    // 判断是通过哪一个URL打开的, 做出相应的处理(跳转到相应的控制器)
    NSString *urlStr = url.absoluteString;
    if ([urlStr hasPrefix:@"sina://login"]) {
        
        // 截取打开我们程序的应用的scheme
        NSRange range = [urlStr rangeOfString:@"sina://login?myScheme="];
        NSString *scheme = [urlStr substringFromIndex:range.length];
        
        NSLog(@"跳转到授权界面 %@", scheme);
        //        if ([vc isKindOfClass:[ViewController class]] == YES) {
        [vc performSegueWithIdentifier:@"home2accounts" sender:scheme];
        //        }
        
    }else if ([urlStr hasPrefix:@"sina://view?id="])
    {
        NSLog(@"跳转到详情界面");
        [vc performSegueWithIdentifier:@"home2detail" sender:nil];
        
    }
    
    return YES;
}
@end
