//
//  ViewController.m
//  01-新浪
//
//  Created by apple on 14/11/2.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"

@interface ViewController ()

- (IBAction)openWangYi;
@end

@implementation ViewController


/**
 *  打开网易新闻
 */
- (IBAction)openWangYi {
    
    // 1.获取application对象
    UIApplication *app = [UIApplication sharedApplication];
    // 2.创建需要打开的应用程序的URL
    // 在应用程序跳转中, 只要有协议头即可, 路径可有可无
    NSURL *url = [NSURL URLWithString:@"wangyi://"];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"首页 %@", sender);
    UIViewController *vc = segue.destinationViewController;
    if ([vc isKindOfClass:[TableViewController class]]) {
        // 如果跳转的目标控制器是授权,才需要设置Scheme
        TableViewController *tbVc = vc;
        tbVc.callScheme = sender;
    }
}
@end
