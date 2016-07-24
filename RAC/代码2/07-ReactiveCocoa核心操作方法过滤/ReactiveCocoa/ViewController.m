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
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // skip;跳跃几个值
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    
    [[subject skip:2] subscribeNext:^(id x) {
       
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [subject sendNext:@"3"];
  
}

- (void)distinctUntilChanged
{
    // distinctUntilChanged:如果当前的值跟上一个值相同,就不会被订阅到
    
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    
    [[subject distinctUntilChanged] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [subject sendNext:@"2"];
}

- (void)take
{
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    
    RACSubject *signal = [RACSubject subject];
    
    // take:取前面几个值
    // takeLast:取后面多少个值.必须要发送完成
    // takeUntil:只要传入信号发送完成或者发送任意数据,就不能在接收源信号的内容
    [[subject takeUntil:signal] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@"1"];
    
    //    [signal sendNext:@1];
    //    [signal sendCompleted];
    [signal sendError:nil];
    
    [subject sendNext:@"2"];
    [subject sendNext:@"3"];

}

- (void)ignore
{
    
    // ignore:忽略一些值
    // ignoreValues:忽略所有的值
    
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 2.忽略一些
    RACSignal *ignoreSignal = [subject ignoreValues];
    
    // 3.订阅信号
    [ignoreSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    // 4.发送数据
    [subject sendNext:@"13"];
    [subject sendNext:@"2"];
    [subject sendNext:@"44"];

}
- (void)filter
{
    // 只有当我们文本框的内容长度大于5,才想要获取文本框的内容
    [[_textField.rac_textSignal filter:^BOOL(id value) {
        // value:源信号的内容
        return  [value length] > 5;
        // 返回值,就是过滤条件,只有满足这个条件,才能能获取到内容
        
    }] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
