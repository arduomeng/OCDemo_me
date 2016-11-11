//
//  OriView.m
//  08-hitTest练习(掌握)
//
//  Created by xiaomage on 15/9/10.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "OriView.h"

@interface OriView ()

@property (nonatomic, weak) IBOutlet UIButton *btn;

@end

@implementation OriView

// UIApplication -> UIWindow -> whiteView -> oriView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__func__);
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    // 判断下点在不在按钮上
    // 转换坐标系
    CGPoint btnP = [self convertPoint:point toView:self.btn];

    // 获取按钮
    if ([self.btn pointInside:btnP withEvent:event]) {
        // 点在按钮上
        return self.btn;
    }else{
        return [super hitTest:point withEvent:event];
    }
}

@end
