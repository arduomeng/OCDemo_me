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
@property (weak, nonatomic) IBOutlet UITextField *accountFiled;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 组合
    // 组合哪些信号
    // reduce:聚合
    
    // reduceBlock参数:根组合的信号有关,一一对应
    RACSignal *comineSiganl = [RACSignal combineLatest:@[_accountFiled.rac_textSignal,_pwdField.rac_textSignal] reduce:^id(NSString *account,NSString *pwd){
        // block:只要源信号发送内容就会调用,组合成新一个值
        NSLog(@"%@ %@",account,pwd);
        // 聚合的值就是组合信号的内容
       
        return @(account.length && pwd.length);
    }];
    
    // 订阅组合信号
//    [comineSiganl subscribeNext:^(id x) {
//        _loginBtn.enabled = [x boolValue];
//    }];
    
    RAC(_loginBtn,enabled) = comineSiganl;
    
   
    
    
}

- (void)zip
{
    // zipWith:夫妻关系
    // 创建信号A
    RACSubject *signalA = [RACSubject subject];
    
    // 创建信号B
    RACSubject *signalB = [RACSubject subject];
    
    // 压缩成一个信号
    // zipWith:当一个界面多个请求的时候,要等所有请求完成才能更新UI
    // zipWith:等所有信号都发送内容的时候才会调用
    RACSignal *zipSignal = [signalA zipWith:signalB];
    
    // 订阅信号
    [zipSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    // 发送信号
    [signalB sendNext:@2];
    [signalA sendNext:@1];

}

// 任意一个信号请求完成都会订阅到
- (void)merge
{
    // 创建信号A
    RACSubject *signalA = [RACSubject subject];
    
    // 创建信号B
    RACSubject *signalB = [RACSubject subject];
    
    // 组合信号
    RACSignal *mergeSiganl = [signalA merge:signalB];
    
    // 订阅信号
    [mergeSiganl subscribeNext:^(id x) {
        // 任意一个信号发送内容都会来这个block
        NSLog(@"%@",x);
    }];
    
    // 发送数据
    [signalB sendNext:@"下部分"];
    [signalA sendNext:@"上部分"];
}

- (void)then
{
    // 创建信号A
    RACSignal *siganlA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        NSLog(@"发送上部分请求");
        // 发送信号
        [subscriber sendNext:@"上部分数据"];
        
        // 发送完成
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    // 创建信号B
    RACSignal *siganlB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        NSLog(@"发送下部分请求");
        // 发送信号
        [subscriber sendNext:@"下部分数据"];
        
        return nil;
    }];
    
    // 创建组合信号
    // then:忽悠掉第一个信号所有值
    RACSignal *thenSiganl = [siganlA then:^RACSignal *{
        // 返回信号就是需要组合的信号
        return siganlB;
    }];
    
    // 订阅信号
    [thenSiganl subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];

}

- (void)concat
{
    // 组合
    // concat:皇上,皇太子
    // 创建信号A
    RACSignal *siganlA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        NSLog(@"发送上部分请求");
        // 发送信号
        [subscriber sendNext:@"上部分数据"];
        
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    RACSignal *siganlB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        NSLog(@"发送下部分请求");
        // 发送信号
        [subscriber sendNext:@"下部分数据"];
        
        return nil;
    }];
    
    // concat:按顺序去连接
    // 注意:concat,第一个信号必须要调用sendCompleted
    // 创建组合信号
    RACSignal *concatSignal = [siganlA concat:siganlB];
    
    // 订阅组合信号
    [concatSignal subscribeNext:^(id x) {
        
        // 既能拿到A信号的值,又能拿到B信号的值
        NSLog(@"%@",x);
        
    }];

}



@end
