//
//  ViewController.m
//  09-hitTest练习2
//
//  Created by xiaomage on 15/9/10.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "ViewController.h"

#import "popButton.h"

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)btnClick:(popButton *)sender {
    
    // 弹出对话框
    
    UIButton *chatView = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [chatView setBackgroundImage:[UIImage imageNamed:@"对话框"] forState:UIControlStateNormal];
    
    [chatView setBackgroundImage:[UIImage imageNamed:@"小孩"] forState:UIControlStateHighlighted];
    
    // 尺寸自适应,会自动计算当前控件的位置跟图片和文字
    [chatView sizeToFit];
    
    sender.chatView = chatView;
    
    
    chatView.center = CGPointMake(chatView.bounds.size.width * 0.5, -chatView.bounds.size.height * 0.5);
    
//    chatView.center = CGPointMake(0, 0);
    
    [sender addSubview:chatView];
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
