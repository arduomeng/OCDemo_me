//
//  ViewController.m
//  03-CoreMotion的使用
//
//  Created by xiaomage on 15/8/20.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()

/** 运动管理 */
@property (nonatomic, strong) CMMotionManager *mgr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 获取磁力计传感器的值
    // 1.判断磁力计是否可用
    if (!self.mgr.isMagnetometerAvailable) {
        return;
    }
    
    // 2.设置采样间隔
    self.mgr.magnetometerUpdateInterval = 0.3;
    
    // 3.开始采样
    [self.mgr startMagnetometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMagnetometerData *magnetometerData, NSError *error) {
        if (error) return;
        
        CMMagneticField field = magnetometerData.magneticField;
        NSLog(@"x:%f y:%f z:%f", field.x, field.y, field.z);
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 1.获取加速计信息
    CMAcceleration acceleration = self.mgr.accelerometerData.acceleration;
    NSLog(@"x:%f y:%f z:%f", acceleration.x, acceleration.y, acceleration.z);
    
    // 2.获取陀螺仪信息
    CMRotationRate rate = self.mgr.gyroData.rotationRate;
    NSLog(@"x:%f y:%f z:%f", rate.x, rate.y, rate.z);
}

#pragma mark - 获取陀螺仪信息
- (void)pullGyro
{
    // pull
    // 1.判断陀螺仪是否可用
    if (![self.mgr isGyroAvailable]) {
        NSLog(@"手机该换了");
        return;
    }
    
    // 2.开始采样
    [self.mgr startGyroUpdates];
}

- (void)pushGyro
{
    // push
    // 1.判断陀螺仪是否可用
    if (![self.mgr isGyroAvailable]) {
        NSLog(@"手机该换了");
        return;
    }
    
    // 2.设置采样间隔
    self.mgr.gyroUpdateInterval = 0.3;
    
    // 3.开始采样
    [self.mgr startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData *gyroData, NSError *error) {
        if (error) return;
        
        CMRotationRate rate = gyroData.rotationRate;
        NSLog(@"x:%f y:%f z:%f", rate.x, rate.y, rate.z);
    }];
}

#pragma mark - 获取加速计信息
- (void)pullAccelerometer
{
    // pull
    // 1.判断加速计是否可用
    if (!self.mgr.isAccelerometerAvailable) {
        NSLog(@"加速计不可用");
        return;
    }
    
    // 2.开始采样
    [self.mgr startAccelerometerUpdates];
}

- (void)pushAccelerometer
{
    // push
    // 1.判断加速计是否可用
    if (!self.mgr.isAccelerometerAvailable) {
        NSLog(@"加速计不可用");
        return;
    }
    
    // 2.设置采样间隔
    self.mgr.accelerometerUpdateInterval = 0.3;
    
    // 3.开始采样
    [self.mgr startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) { // 当采样到加速计信息时就会执行
        if (error) return;
        
        // 获取加速计信息
        CMAcceleration acceleration = accelerometerData.acceleration;
        NSLog(@"x:%f y:%f z:%f", acceleration.x, acceleration.y, acceleration.z);
    }];
}

#pragma mark - 懒加载
- (CMMotionManager *)mgr
{
    if (_mgr == nil) {
        _mgr = [[CMMotionManager alloc] init];
    }
    return _mgr;
}

@end
