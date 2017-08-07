//
//  AppDelegate.m
//  ShareExtension
//
//  Created by user on 2017/4/27.
//  Copyright © 2017年 user. All rights reserved.
//

#import "AppDelegate.h"
#import "CSUtil.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    
    /* 
     分享跳转进来分为两种情况
     1. 点击乐秀
     url = videoshow://
     2. 点击用“乐秀”导入
     url = file:///private/var/mobile/Containers/Data/Application/068C0FEF-0222-415B-9DC0-942C9CE9AC25/Documents/Inbox/IMG_20160201_191112.jpg // 文件存储位置
     */
    if ([url.absoluteString hasPrefix:@"videoshow"]) {
        //获取共享的UserDefaults
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.videoshow"];
        
        NSArray *imageArr = [userDefaults valueForKey:@"imageArr"];
        NSArray *movieArr = [userDefaults valueForKey:@"movieArr"];
        
        NSLog(@"imageArr : %@", [userDefaults valueForKey:@"imageArr"]);
        NSLog(@"movieArr : %@", [userDefaults valueForKey:@"movieArr"]);
        
        NSString *relativeFilePath = nil;
        NSString *absoluteFilePath = nil;
        
        // 视频
        for (NSString *movieStr in movieArr) {
            
            
            // 外部视频
            if ([movieStr hasPrefix:@"file:///private"]) {
                
                
                
                
                
                relativeFilePath = [self relativeFilePathWith:movieStr];
                absoluteFilePath = [[CSUtil cachesDirectory] stringByAppendingPathComponent:relativeFilePath];
                NSURL *fileURL = [NSURL fileURLWithPath:absoluteFilePath];
                
                // 写入data数据至文件共享区,用data的方式当视频较大时会内存溢出，程序崩溃
                // 读取文件并写入沙盒
                // NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:movieStr]];
                // 写入文件
                // [data writeToURL:fileURL atomically:YES];
                
                NSError *error = nil;
                [[NSFileManager defaultManager] removeItemAtURL:fileURL error:nil];
                [[NSFileManager defaultManager] copyItemAtURL:[NSURL URLWithString:movieStr] toURL:fileURL error:&error];
                
                if (!error) {
                    AVAsset *asset = [AVAsset assetWithURL:fileURL];
                    NSLog(@"%f", CMTimeGetSeconds(asset.duration));
                }
                
                
            }
            // 图库视频
            else{
                relativeFilePath = movieStr;
                absoluteFilePath = movieStr;
                
                AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:relativeFilePath]];
                NSLog(@"%f", CMTimeGetSeconds(asset.duration));
            }
        }
        // 图片
        for (NSString *imageStr in imageArr) {
            
            //读取文件并写入沙盒
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]];
            
            relativeFilePath = [self relativeFilePathWith:imageStr];
            absoluteFilePath = [[CSUtil cachesDirectory] stringByAppendingPathComponent:relativeFilePath];
            NSURL *fileURL = [NSURL fileURLWithPath:absoluteFilePath];
            
            //写入文件
            [data writeToURL:fileURL atomically:YES];
            
            
            NSData *imageData = [NSData dataWithContentsOfURL:fileURL];
            UIImage *img = [UIImage imageWithData:imageData];
            NSLog(@"%@", img);
        }
        
    }else if([url.absoluteString hasPrefix:@"file://"]){
        
        //NSURL转NSString的问题，需要用UTF-8处理下逃逸符
        NSString *path = [url absoluteString];
        path = [path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@", path);
    }
    return YES;
}

- (NSString *)relativeFilePathWith:(NSString *)shareFilePath{
    
    NSString *relativeFilePath = nil;
    NSRange range = [shareFilePath rangeOfString:@"/" options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        
        relativeFilePath = [shareFilePath substringFromIndex:range.location + range.length];
    }
    
    return relativeFilePath;
}

- (void)loadAssetsAuthorizationStatus{
    // 判断相册权限
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusRestricted:
            NSLog(@"系统原因无法访问相册");
            break;
        case PHAuthorizationStatusDenied:
            NSLog(@"提醒用户打开权限");
            break;
        case PHAuthorizationStatusAuthorized:
            //[self loadAssetsAlbums];
            break;
        case PHAuthorizationStatusNotDetermined:
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if (status == PHAuthorizationStatusDenied) {
                        NSLog(@"提醒用户打开权限");
                    }else{
                        //[self loadAssetsAlbums];
                    }
                });
                
            }];
            break;
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    return YES;
}



- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

@end
