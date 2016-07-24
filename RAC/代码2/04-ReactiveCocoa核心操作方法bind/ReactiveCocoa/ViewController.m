//
//  ViewController.m
//  ReactiveCocoa
//
//  Created by xiaomage on 15/10/25.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "ViewController.h"

#import "GlobeHeader.h"'

#import "RACReturnSignal.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 2.绑定信号
    RACSignal *bindSignal = [subject bind:^RACStreamBindBlock{
        // block调用时刻:只要绑定信号被订阅就会调用
        
        
        return ^RACSignal *(id value, BOOL *stop){
            // block调用:只要源信号发送数据,就会调用block
            // block作用:处理源信号内容
            // value:源信号发送的内容
            
            NSLog(@"接收到原信号的内容:%@",value);
            
            value = [NSString stringWithFormat:@"xmg:%@",value];
            // 返回信号,不能传nil,返回空信号[RACSignal empty]
            return [RACReturnSignal return:value];
        };
    }];
    
    // 3.订阅绑定信号
    [bindSignal subscribeNext:^(id x) {
       // blcok:当处理完信号发送数据的时候,就会调用这个Block
        NSLog(@"接收到绑定信号处理完的信号%@",x);
    }];
    
    // 4.发送数据
    [subject sendNext:@"123"];
    
}



@end
