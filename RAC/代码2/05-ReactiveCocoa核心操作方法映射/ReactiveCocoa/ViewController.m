//
//  ViewController.m
//  ReactiveCocoa
//
//  Created by xiaomage on 15/10/25.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "ViewController.h"

#import "GlobeHeader.h"

#import "RACReturnSignal.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // flattenMap:用于信号中信号
 
    RACSubject *signalOfsignals = [RACSubject subject];
    
    RACSubject *signal = [RACSubject subject];
    
    // 订阅信号
//    [signalOfsignals subscribeNext:^(RACSignal *x) {
//        
//        [x subscribeNext:^(id x) {
//            NSLog(@"%@",x);
//        }];
//        
//    }];
    
//    RACSignal *bindSignal = [signalOfsignals flattenMap:^RACStream *(id value) {
//        // value:源信号发送内容
//        return value;
//    }];
//    
//    [bindSignal subscribeNext:^(id x) {
//        
//        NSLog(@"%@",x);
//    }];
    [[signalOfsignals flattenMap:^RACStream *(id value) {
        return value;
        
    }] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    
    // 发送信号
    [signalOfsignals sendNext:signal];
    [signal sendNext:@"213"];
}

- (void)map
{
    // @"123"
    // @"xmg:123"
    
    // 创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 绑定信号
    RACSignal *bindSignal = [subject map:^id(id value) {
        // 返回的类型,就是你需要映射的值
        return [NSString stringWithFormat:@"xmg:%@",value];
        
    }];
    
    // 订阅绑定信号
    [bindSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@"123"];
    [subject sendNext:@"321"];
}

- (void)flattenMap
{
    // 创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 绑定信号
    RACSignal *bindSignal = [subject flattenMap:^RACStream *(id value) {
        // block:只要源信号发送内容就会调用
        // value:就是源信号发送内容
        
        value = [NSString stringWithFormat:@"xmg:%@",value];
        
        // 返回信号用来包装成修改内容值
        return [RACReturnSignal return:value];
        
    }];
    
    // flattenMap中返回的是什么信号,订阅的就是什么信号
    
    // 订阅信号
    [bindSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    
    // 发送数据
    [subject sendNext:@"123"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
