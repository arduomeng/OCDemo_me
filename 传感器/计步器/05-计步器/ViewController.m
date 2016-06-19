//
//  ViewController.m
//  05-计步器
//
//  Created by xiaomage on 15/8/20.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()

/** 计步器对象 */
@property (nonatomic, strong) CMStepCounter *counter;
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.判断计步器是否可用
    if (![CMStepCounter isStepCountingAvailable]) {
        NSLog(@"计步器不可用");
        return;
    }
    
    // 2.开始计步
    [self.counter startStepCountingUpdatesToQueue:[NSOperationQueue mainQueue] updateOn:5 withHandler:^(NSInteger numberOfSteps, NSDate *timestamp, NSError *error) {
        if (error) return;
        
        self.stepLabel.text = [NSString stringWithFormat:@"您一共走了%ld步", numberOfSteps];
    }];
}

#pragma mark - 懒加载代码
- (CMStepCounter *)counter
{
    if (_counter == nil) {
        _counter = [[CMStepCounter alloc] init];
    }
    return _counter;
}

@end
