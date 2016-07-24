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
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 只要这个对象的属性一改变就会产生信号
//    [RACObserve(self.view, frame) subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
    
    // 包装元组
    RACTuple *tuple = RACTuplePack(@1,@2);
    
    NSLog(@"%@",tuple[0]);
    
    
    
}

- (void)RAC
{
    // 监听文本框内容
    //    [_textField.rac_textSignal subscribeNext:^(id x) {
    //
    //        _label.text = x;
    //    }];
    
    // 用来给某个对象的某个属性绑定信号,只要产生信号内容,就会把内容给属性赋值
    RAC(_label,text) = _textField.rac_textSignal;
}

- (void)liftSelector
{
    // 当一个界面有多次请求时候,需要保证全部都请求完成,才搭建界面
    
    // 请求热销模块
    RACSignal *hotSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 请求数据
        // AFN
        NSLog(@"请求数据热销模块");
        
        [subscriber sendNext:@"热销模块的数据"];
        
        return nil;
    }];
    
    // 请求最新模块
    RACSignal *newSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 请求数据
        NSLog(@"请求最新模块");
        
        [subscriber sendNext:@"最新模块数据"];
        
        return nil;
    }];
    
    // 数组:存放信号
    // 当数组中的所有信号都发送数据的时候,才会执行Selector
    // 方法的参数:必须跟数组的信号一一对应
    // 方法的参数;就是每一个信号发送的数据
    [self rac_liftSelector:@selector(updateUIWithHotData:newData:) withSignalsFromArray:@[hotSignal,newSignal]];
}

- (void)updateUIWithHotData:(NSString *)hotData newData:(NSString *)newData
{
    // 拿到请求的数据
    NSLog(@"更新UI %@ %@",hotData,newData);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
