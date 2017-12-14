//
//  ViewController.m
//  CSCALayer
//
//  Created by LCS on 16/3/20.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self CAGradientLayer];
    [self CAReplicatorLayer];
}
//渐变图层
- (void)CAGradientLayer{
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    gradientLayer.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 50, 50, 100, 100);
    //设置渐变数组
    gradientLayer.colors = @[(id)[UIColor redColor].CGColor, (id)[UIColor greenColor].CGColor, (id)[UIColor blueColor].CGColor];
    //设置渐变位置,颜色所占比例 ？ 怎么配比？
    gradientLayer.locations = @[@0.1, @0.8];
    //设置渐变开始点
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    
    [self.view.layer addSublayer:gradientLayer];
}

//复制图层,可以复制它的子图层
- (void)CAReplicatorLayer{
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    
    replicatorLayer.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 50, 200, 100, 100);
    replicatorLayer.backgroundColor = [UIColor grayColor].CGColor;
    
    [self.view.layer addSublayer:replicatorLayer];
    
    CALayer *layer = [CALayer layer];
    layer.bounds = CGRectMake(0, 0, 10, 10);
    layer.position = CGPointMake(replicatorLayer.bounds.size.width/2, 20);
    layer.backgroundColor = [UIColor colorWithRed:90/255.0 green:221/255.0 blue:220/255.0 alpha:1].CGColor;
    layer.cornerRadius = 5;
    
    CABasicAnimation *basic = [[CABasicAnimation alloc] init];
    basic.duration = 0.5;
    basic.keyPath = @"transform.scale";
    basic.toValue = @0.1;
    basic.repeatCount = MAXFLOAT;
    
    [layer addAnimation:basic forKey:nil];
    
    [replicatorLayer addSublayer:layer];
    
    
    // 复制层中子层总数
    // instanceCount：表示复制层里面有多少个子层，包括原始层
    NSInteger instanceCount = 10;
    replicatorLayer.instanceCount = instanceCount;
    
    // 设置复制子层偏移量，不包括原始层,相对于原始层x偏移
    replicatorLayer.instanceTransform = CATransform3DMakeRotation(2 * M_PI / instanceCount, 0, 0, 1);
    
    // 设置复制层动画延迟时间
    replicatorLayer.instanceDelay = 0.5 / instanceCount;
}

@end
