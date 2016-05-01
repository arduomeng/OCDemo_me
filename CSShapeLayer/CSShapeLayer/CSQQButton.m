//
//  CSQQButton.m
//  CSShapeLayer
//
//  Created by LCS on 16/3/25.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "CSQQButton.h"
#import "UIView+Extensions.h"

#define kmaxOffset 30.0
// 最大圆心距离
#define kmaxDistance 80

@interface CSQQButton ()

@property (nonatomic, weak) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) UIView     *centerView;

@end

@implementation CSQQButton

- (CAShapeLayer *)shapeLayer{
    if (!_shapeLayer) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        [self.superview.layer addSublayer:shapeLayer];
        _shapeLayer = shapeLayer;
    }
    return _shapeLayer;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpButton];
    }
    return self;
}

//初始化按钮
- (void) setUpButton{
    
    [self setBackgroundColor:[UIColor redColor]];
    [self setTitle:@"10" forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont systemFontOfSize:13]];
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.masksToBounds = YES;
    
    //添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    [self addGestureRecognizer:pan];
    
    //添加中心圆
    
}

- (void)panHandler:(UIPanGestureRecognizer *)recognizer{
    //拖拽的时候再来创建centerView 如果在初始化方法中创建centerView。则self.superView不存在，因为夫视图还没有添加自己
    if (!_centerView) {
        UIView *view = [[UIView alloc] init];
        [self.superview insertSubview:view belowSubview:self];
        _centerView = view;
        _centerView.backgroundColor = [UIColor redColor];
        _centerView.center = self.center;
        _centerView.bounds = self.bounds;
        _centerView.layer.cornerRadius = self.frame.size.width / 2;
    }
    
    //按钮拖拽响应
    CGPoint point = [recognizer locationInView:self.superview];
    self.center = point;
    
    //根据偏移量缩小中心圆
    CGFloat distance = [self DistanceWithBigCircleCenter:self.center smallCircleCenter:_centerView.center];
    if (distance) {
        
    }
    
    // 当圆心距离大于最大圆心距离
    if (distance > kmaxDistance) { // 可以拖出来
        // 隐藏小圆
        _centerView.hidden = YES;
        
        // 移除不规则的矩形
        [self.shapeLayer removeFromSuperlayer];
        
    }else if(distance > 0 && _centerView.hidden == NO){ // 有圆心距离，并且圆心距离不大，才需要展示
        CGFloat narrow = self.width / 2 - distance / 10;
        NSLog(@"narrow %f", narrow);
        _centerView.layer.cornerRadius = narrow;
        _centerView.bounds = CGRectMake(0, 0, narrow * 2, narrow * 2);
    
        //设置不规则图层
        self.shapeLayer.path = [self bezierPathWithBigCircleView:self smallCircleView:_centerView].CGPath;
        self.shapeLayer.fillColor = self.backgroundColor.CGColor;
    }
    
    //按钮回到原来的位置
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        // 当圆心距离大于最大圆心距离
        if (distance > kmaxDistance) {
            
            // 展示gif动画
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
            
            NSMutableArray *arrM = [NSMutableArray array];
            for (int i = 1; i < 9; i++) {
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
                [arrM addObject:image];
            }
            imageView.animationImages = arrM;
            
            imageView.animationRepeatCount = 1;
            
            imageView.animationDuration = 1;
            
            [imageView startAnimating];
            
            [self addSubview:imageView];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 移除按钮
                [self removeFromSuperview];
            });
            
        }else{
            // 移除不规则矩形
            [self.shapeLayer removeFromSuperlayer];
            
            // 还原位置
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.center = _centerView.center;
            } completion:^(BOOL finished) {
                //显示小圆
                _centerView.hidden = NO;
            }];
            
        }
        
    }
}

//计算两点间距离
- (CGFloat)DistanceWithBigCircleCenter:(CGPoint)bigCircleCenter smallCircleCenter:(CGPoint)smallCircleCenter
{
    CGFloat offsetX = bigCircleCenter.x - smallCircleCenter.x;
    CGFloat offsetY = bigCircleCenter.y - smallCircleCenter.y;
    
    return  sqrt(offsetX * offsetX + offsetY * offsetY);
}

//计算不规则图层路径
- (UIBezierPath *)bezierPathWithBigCircleView:(UIView *)bigCirCleView smallCircleView:(UIView *)smallCirCleView{
    
    CGPoint bigCenter = bigCirCleView.center;
    CGFloat x2 = bigCenter.x;
    CGFloat y2 = bigCenter.y;
    CGFloat r2 = bigCirCleView.bounds.size.width / 2;
    
    CGPoint smallCenter = smallCirCleView.center;
    CGFloat x1 = smallCenter.x;
    CGFloat y1 = smallCenter.y;
    CGFloat r1 = smallCirCleView.bounds.size.width / 2;
    
    // 获取圆心距离
    CGFloat d = [self DistanceWithBigCircleCenter:bigCenter smallCircleCenter:smallCenter];
    
    CGFloat sinθ = (x2 - x1) / d;
    
    CGFloat cosθ = (y2 - y1) / d;
    
    // 坐标系基于父控件
    CGPoint pointA = CGPointMake(x1 - r1 * cosθ , y1 + r1 * sinθ);
    CGPoint pointB = CGPointMake(x1 + r1 * cosθ , y1 - r1 * sinθ);
    CGPoint pointC = CGPointMake(x2 + r2 * cosθ , y2 - r2 * sinθ);
    CGPoint pointD = CGPointMake(x2 - r2 * cosθ , y2 + r2 * sinθ);
    CGPoint pointO = CGPointMake(pointA.x + d / 2 * sinθ , pointA.y + d / 2 * cosθ);
    CGPoint pointP =  CGPointMake(pointB.x + d / 2 * sinθ , pointB.y + d / 2 * cosθ);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // A
    [path moveToPoint:pointA];
    
    // AB
    [path addLineToPoint:pointB];
    
    // 绘制BC曲线
    [path addQuadCurveToPoint:pointC controlPoint:pointP];
    
    // CD
    [path addLineToPoint:pointD];
    
    // 绘制DA曲线
    [path addQuadCurveToPoint:pointA controlPoint:pointO];
    
    return path;
    
}
@end
