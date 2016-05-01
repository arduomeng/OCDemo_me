//
//  ViewController.m
//  GCD进程间通行
//
//  Created by LCS on 16/4/9.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self operation];
}

- (void)gcd{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        //下载图片
        NSURL *url = [NSURL URLWithString:@"http://d.hiphotos.baidu.com/baike/c0%3Dbaike116%2C5%2C5%2C116%2C38/sign=c20db199af014c080d3620f76b12696d/42166d224f4a20a46d0a00f796529822720ed0ed.jpg"];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        //回到主线程设置图片
        /*
            因为是主队列，所以回到主队列串行执行，不会创建新线程。
            async和sync的区别：
            
            async：
                该任务执行完NSLog(@"download end!");，再回到主线程设置图片
            sync：
                先回到主队列设置图片，再执行NSLog(@"download end!");
         */
        dispatch_async(dispatch_get_main_queue(), ^{
            _imageview.image = [UIImage imageWithData:data];
        });
        NSLog(@"download end!");
    });
}

- (void)operation{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [queue addOperationWithBlock:^{
        //下载图片
        NSURL *url = [NSURL URLWithString:@"http://d.hiphotos.baidu.com/baike/c0%3Dbaike116%2C5%2C5%2C116%2C38/sign=c20db199af014c080d3620f76b12696d/42166d224f4a20a46d0a00f796529822720ed0ed.jpg"];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            _imageview.image = [UIImage imageWithData:data];
        }];
    }];
}


@end
