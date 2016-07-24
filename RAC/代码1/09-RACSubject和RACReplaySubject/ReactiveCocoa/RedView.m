//
//  RedView.m
//  ReactiveCocoa
//
//  Created by xiaomage on 15/10/25.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "RedView.h"

@implementation RedView

- (RACSubject *)btnClickSignal
{
    if (_btnClickSignal == nil) {
        _btnClickSignal = [RACSubject subject];
    }
    return _btnClickSignal;
}

- (IBAction)btnClick:(id)sender
{
//    NSLog(@"红色view监听到按钮点击");
    // 通知控制器处理
    [self.btnClickSignal sendNext:@"按钮被点击"];
    
    
}

@end
