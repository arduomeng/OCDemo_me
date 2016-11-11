//
//  popButton.m
//  09-hitTest练习2
//
//  Created by xiaomage on 15/9/10.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "popButton.h"

@implementation popButton

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    // 判断下点在不在chatView上
    CGPoint chatP = [self convertPoint:point toView:self.chatView];
    if ([self.chatView pointInside:chatP withEvent:event] == YES) {
        return self.chatView;
    }else{
        return [super hitTest:point withEvent:event];
    }
}

// 只要手指在控件上移动的时候调用
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    // 获取UITouch
    UITouch *touch = [touches anyObject];
    
    // 获取当前点
    CGPoint curP = [touch locationInView:self];
    CGPoint preP = [touch previousLocationInView:self];
    
    // 让按钮随着手指移动而移动
    // 获取手指的偏移量
    CGFloat offsetX = curP.x - preP.x;
    CGFloat offsetY = curP.y - preP.y;
    
    // 移动按钮
    self.transform = CGAffineTransformTranslate(self.transform, offsetX, offsetY);
    
}

@end
