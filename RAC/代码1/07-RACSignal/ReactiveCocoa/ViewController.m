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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // RACSignal:有数据产生的时候,就使用RACSignal
    
    // RACSignal使用步骤: 1.创建信号  2.订阅信号 3.发送信号
    
    RACDisposable *(^didSubscribe)(id<RACSubscriber> subscriber) = ^RACDisposable *(id<RACSubscriber> subscriber) {
        // didSubscribe调用:只要一个信号被订阅就会调用
        // didSubscribe作用:发送数据
        NSLog(@"信号被订阅");
        // 3.发送数据
        [subscriber sendNext:@1];
        
        return nil;
    };
    
    // 1.创建信号(冷信号)
    RACSignal *signal = [RACSignal createSignal:didSubscribe];
    
    // 2.订阅信号(热信号)
    [signal subscribeNext:^(id x) {
        
        // nextBlock调用:只要订阅者发送数据就会调用
        // nextBlock作用:处理数据,展示到UI上面
        
        // x:信号发送的内容
        NSLog(@"%@",x);
    }];
    
    // 只要订阅者调用sendNext,就会执行nextBlock
    // 只要订阅RACDynamicSignal,就会执行didSubscribe
    // 前提条件是RACDynamicSignal,不同类型信号的订阅,处理订阅的事情不一样
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
