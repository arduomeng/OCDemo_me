//
//  RedView.m
//  Quartz 2D
//
//  Created by LCS on 16/7/16.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "RedView.h"

@implementation RedView

// 在view即将显示的时候调用
- (void)drawRect:(CGRect)rect{
    // 1.取得一个跟view相关联的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 2.设置路径
    
    // 扇形进度条
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 100) radius:50 startAngle:-M_PI_2 endAngle:-M_PI_2 + M_PI * 2 * _progress clockwise:YES];
    // 添加线到圆心
    [path addLineToPoint:CGPointMake(100, 100)];
    // 关闭路径
    [path closePath];
    
    // 3.将路径添加到上下文
    CGContextAddPath(ctx, path.CGPath);
    // 4.显示上下文的内容 Stroke描边  fill填充
    // CGContextSetLineWidth(ctx, 10);
    // CGContextStrokePath(ctx);
    
    [[UIColor blueColor] setFill];
    CGContextFillPath(ctx);
    
    // 画文字
    NSString *str = @"加油";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [str drawAtPoint:CGPointMake(0, 0) withAttributes:dic];
    
    // 画图片
    UIImage *image = [UIImage imageNamed:@"qq"];
    [image drawInRect:CGRectMake(0, 0, 60, 60)];
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    
    // 设置一个标志，当下一次屏幕刷新的时候调用
    [self setNeedsDisplay];
}

@end
