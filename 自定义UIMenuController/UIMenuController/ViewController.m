//
//  ViewController.m
//  UIMenuController
//
//  Created by Apple on 16/5/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "menuLabel.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet menuLabel *label;

@end

/*
    默认情况下支持menuController的控件
    1.UITextField
    2.UITextView
    3.UIWebView
 */


@implementation ViewController

- (void)viewDidLoad {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelOnclick)];
    [self.label addGestureRecognizer:tap];
}

- (void)ding:(id)sender{
    NSLog(@"ding");
}

- (void)cai:(id)sender{
    NSLog(@"cai");
}

- (void)labelOnclick{
    // 1.label成为第一响应者
    [self.label becomeFirstResponder];
    
    // 2.显示menuController
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:self.label.frame inView:self.label.superview];
    
    UIMenuItem *item1 = [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)];
    UIMenuItem *item2 = [[UIMenuItem alloc] initWithTitle:@"踩" action:@selector(cai:)];
    // 给menu添加item
    menu.menuItems = @[item1, item2];
    
    [menu setMenuVisible:YES animated:YES];
}


@end
