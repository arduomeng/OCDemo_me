//
//  ViewController.m
//  ReactiveCocoa
//
//  Created by xiaomage on 15/10/25.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "ViewController.h"

#import "GlobeHeader.h"


#import "RedVIew.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet RedVIew *redView;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 2.代替KVO
//    [_redView rac_observeKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
//        //
//        
//    }];
    
    
    
//    [[_redView rac_valuesForKeyPath:@"frame" observer:nil] subscribeNext:^(id x) {
//      // x:修改的值
//        NSLog(@"%@",x);
//    }];
    
//    [_redView rac_observeKeyPath:@"bounds" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
//        //
//        
//    }];
    

    
    // 3.监听事件
  
//    [[_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        NSLog(@"按钮点击了");
//    }];
    
    
    // 4.代替通知
    
//    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
//        
//        NSLog(@"%@",x);
//    }];
    
    // 5.监听文本框
    [_textField.rac_textSignal subscribeNext:^(id x) {
       
        NSLog(@"%@",x);
    }];
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _redView.frame = CGRectMake(50, 50, 200, 200);
}


- (void)delegate
{
    // 1.代替代理:1.RACSubject 2.rac_signalForSelector
    // 只要传值,就必须使用RACSubject
    [[_redView rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(id x) {
        NSLog(@"控制器知道按钮被点击");
    }];
    
    // RAC:
    // 把控制器调用didReceiveMemoryWarning转换成信号
    // rac_signalForSelector:监听某对象有没有调用某方法
    //    [[self rac_signalForSelector:@selector(didReceiveMemoryWarning)] subscribeNext:^(id x) {
    //        NSLog(@"控制器调用didReceiveMemoryWarning");
    //    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
