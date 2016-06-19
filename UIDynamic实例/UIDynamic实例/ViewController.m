//
//  ViewController.m
//  UIDynamic实例
//
//  Created by Apple on 16/5/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *dynamicView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
// 物理仿真器
@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@end

@implementation ViewController

// 1.创建物理仿真器（ReferenceView,参照试图，仿真范围）
- (UIDynamicAnimator *)dynamicAnimator{
    if (!_dynamicAnimator) {
        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _dynamicAnimator;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint point = [[touches anyObject] locationInView:self.view];
    
    [self snap:point];
}

// 吸附
- (void)snap:(CGPoint)touchPoint{
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.dynamicView snapToPoint:touchPoint];
    // 阻尼系数
    snap.damping = 0.5;
    // 移除原行为
    [self.dynamicAnimator removeAllBehaviors];
    // 添加新行为
    [self.dynamicAnimator addBehavior:snap];
}
// 碰撞
- (void)collision{
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.dynamicView, self.segment]];
    
    // 添加边界
    // 1.让参照视图的bounds变为碰撞监测的边框
     collision.translatesReferenceBoundsIntoBoundary = YES;
    
    // 2.自定义边界
    // 2.1 fromPoint toPoint 线
    // [collision addBoundaryWithIdentifier:<#(nonnull id<NSCopying>)#> fromPoint:<#(CGPoint)#> toPoint:<#(CGPoint)#>];
    // 2.2 UIBezierPath 内塞尔曲线
    // 创建一个椭圆路径
    CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [collision addBoundaryWithIdentifier:@"bezierPath" forPath:path];
    // 添加重力行为
    [self gravity];
    // 添加碰撞行为
    [self.dynamicAnimator addBehavior:collision];
}
// 重力
- (void)gravity{
    // 2.创建物理仿真行为 2.1添加要进行仿真的对象(遵守UIDynamicItem协议)
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self.dynamicView]];
    // 方向
    // gravity.gravityDirection = CGVectorMake(100, 100);
    // 加速度(point/m2)
     gravity.magnitude = 100;
    // 3.添加仿真行为到物理仿真器中，开始仿真
    [self.dynamicAnimator addBehavior:gravity];
}

@end
