//
//  ViewController.m
//  ReactiveCocoa
//
//  Created by xiaomage on 15/10/25.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "ViewController.h"

#import "GlobeHeader.h"

@interface ViewController ()

@property (nonatomic, strong) id<RACSubscriber> subscriber;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber ) {
        
//        _subscriber = subscriber;
        
         // 3.发送信号
        [subscriber sendNext:@"123"];
       
        return [RACDisposable disposableWithBlock:^{
           // 只要信号取消订阅就会来这
            // 清空资源
            NSLog(@"信号被取消订阅了");
        }];
    }];
    
    // 2.订阅信号
    RACDisposable *disposable = [signal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    // 1.创建订阅者,保存nextBlock
    // 2.订阅信号
    
    // 默认一个信号发送数据完毕们就会主动取消订阅.
    // 只要订阅者在,就不会自动取消信号订阅
   // 取消订阅信号
    [disposable dispose];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
