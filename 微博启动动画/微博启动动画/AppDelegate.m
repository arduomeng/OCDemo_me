//
//  AppDelegate.m
//  微博启动动画
//
//  Created by LCS on 16/3/27.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "AppDelegate.h"
#import "weiboWelcome.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //创建欢迎界面。添加到window上面
    
    
    
    //因为控制器的view是懒加载的，所以添加welcomeView的时候，Main.storyboard的控制器view还没有加载。
    //applicationDidBecomeActive当应用程序编程活动的时候在这个方法中加载Main.storyboard。 导致Main控制器覆盖了welcomeView
//    weiboWelcome *welcomeView = [[[NSBundle mainBundle] loadNibNamed:@"weiboWelcome" owner:nil options:nil] lastObject];
//    [self.window addSubview:welcomeView];
    
    //因此取消Main.storyboard的加载改为手动加载方式，主动创建控制器
    UIWindow *window = [[UIWindow alloc] init];
    window.frame = [UIScreen mainScreen].bounds;
    self.window = window;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *viewCtrl = [storyboard instantiateInitialViewController];
    window.rootViewController = viewCtrl;
    [window makeKeyAndVisible];
    
    weiboWelcome *welcomeView = [[[NSBundle mainBundle] loadNibNamed:@"weiboWelcome" owner:nil options:nil] lastObject];
    [self.window addSubview:welcomeView];
    
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
