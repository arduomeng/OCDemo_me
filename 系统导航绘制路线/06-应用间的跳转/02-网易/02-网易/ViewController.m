//
//  ViewController.m
//  02-网易
//
//  Created by apple on 14/11/2.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
- (IBAction)openSina;
- (IBAction)openDetail;
@end

@implementation ViewController
/**
 *  打开新浪授权界面
 */
- (IBAction)openSina
{
    // 每个程序都可以拥有一个自己唯一的URL
    // URL组成: 协议头://主机/路径
    // http://
    // file://
    // ftp://
    // ...
    // 1.获取application对象
    UIApplication *app = [UIApplication sharedApplication];
    // 2.创建需要打开的应用程序的URL
    // 在应用程序跳转中, 只要有协议头即可, 路径可有可无
    NSURL *url = [NSURL URLWithString:@"sina://login?myScheme=wangyi"];
    // 3.利用application打开URL
    if ([app canOpenURL:url]) {
        // 3.1判断是否可以打开
        [app openURL:url];
    }else
    {
        // 3.2打开App STORE下载
        NSLog(@"根据App id打开App STORE");
    }
    
}
/**
 *  打开新浪详情界面
 */
- (IBAction)openDetail
{
    // 1.获取application对象
    UIApplication *app = [UIApplication sharedApplication];
    // 2.创建需要打开的应用程序的URL
    // 在应用程序跳转中, 只要有协议头即可, 路径可有可无
    NSURL *url = [NSURL URLWithString:@"sina://view?id=123456"];
    // 3.利用application打开URL
    if ([app canOpenURL:url]) {
        // 3.1判断是否可以打开
        [app openURL:url];
    }else
    {
        // 3.2打开App STORE下载
        NSLog(@"根据App id打开App STORE");
    }

}

@end
