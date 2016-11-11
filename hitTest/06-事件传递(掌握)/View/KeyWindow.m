//
//  KeyWindow.m
//  06-事件传递(掌握)
//
//  Created by xiaomage on 15/9/10.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "KeyWindow.h"

@implementation KeyWindow
// 作用:寻找最合适view
// 什么时候调用,只要一个事件传递给一个控件,就会调用这个控件的hitTest
// 返回谁,谁就是最合适view
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    // 1.判断下自己能否接收事件
    if (self.userInteractionEnabled == NO || self.hidden == YES || self.alpha <= 0.01) return nil;
    
    // 2.判断下点在不在当前控件上
    if ([self pointInside:point withEvent:event] == NO) return  nil; // 点不在当前控件
        
    
    // 3.从后往前遍历自己的子控件
    // 1 0
    int count = self.subviews.count;
    for (int i = count - 1; i >= 0; i--) {
        // 获取子控件
       UIView *childView = self.subviews[i];
        
        // 把当前坐标系上的点转换成子控件上的点
      CGPoint childP =  [self convertPoint:point toView:childView];
        
       UIView *fitView = [childView hitTest:childP withEvent:event];
        
        if (fitView) {
            return fitView;
        }
        
    }
    
    // 4.如果没有比自己合适的子控件,最合适的view就是自己
    return self;
    
}

// 点击白色view: 触摸事件 -> UIApplication -> [UIWindow hitTest] -> [whiteView hitTest] -> [ori hitTest] -> [green hitTest]



// point:表示方法调用者坐标系上的点
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    
////    UIView *fitView = [super hitTest:point withEvent:event];
//    
////    NSLog(@"%@",fitView);
//    
//    return self.subviews[0];
//}


// 判断下当前这个点在不在方法调用者上
// 使用注意点:点必须是方法调用者上的坐标系,才会判断准备
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
//{
//    return NO;
//}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"%s",__func__);
//}

@end
