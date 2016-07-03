//
//  ViewController.m
//  函数式编程思想
//
//  Created by LCS on 16/7/1.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "ViewController.h"
#import "CalculateManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CalculateManager *mgr = [[CalculateManager alloc] init];
    
    // 将计算操作封装到block中，使得代码集中，模块化编程
    // lcs_calculate返回值为CalculateManager 可以直接调用result方法获得计算结果
    int result = [[mgr lcs_calculate:^int(int result){
        result += 5;
        result *= 5;
        
        return result;
    }] result];
    NSLog(@"%d", result);
}

@end
