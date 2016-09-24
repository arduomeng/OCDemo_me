//
//  yellowView.m
//  事件传递
//
//  Created by LCS on 16/7/25.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "yellowView.h"

@interface yellowView ()

@property (nonatomic, weak) IBOutlet UIView *blueView;

@end

@implementation yellowView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s", __func__);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    CGPoint po = [self convertPoint:point toView:_blueView];
    
    if ([self.blueView pointInside:po withEvent:event]) {
        return self.blueView;
        /**
         *   若blueView没有实现touchBegin方法，则是yellowView响应点击事件
         */
    }else{
        return [super hitTest:point withEvent:event];
    }
}

@end
