//
//  ViewController.m
//  07-系统自带分享
//
//  Created by apple on 14/11/2.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "ViewController.h"
#import <Social/Social.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 1.判断服务是否可用
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
        NSLog(@"分享服务不可用");
    }
    // 2.创建分享控制器
    SLComposeViewController *composeVc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
    
    // 设置默认数据
    [composeVc setInitialText:@"今天天很好, 只不过没出门"];
    [composeVc addImage:[UIImage imageNamed:@"psb-2.jpeg"]];
    
    // 3.弹出分享控制器
    [self presentViewController:composeVc animated:YES completion:nil];
    
    // 4.监听分享状态
    composeVc.completionHandler = ^(SLComposeViewControllerResult result)
    {
        if (result == SLComposeViewControllerResultCancelled) {
            NSLog(@"取消发送");
        }else
        {
            NSLog(@"发送成功");
        }
    };
    
}

@end
