//
//  CalculateManager.m
//  函数式编程思想
//
//  Created by LCS on 16/7/1.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "CalculateManager.h"

@implementation CalculateManager

/**
 *  计算方法
 *
 *  @param block 返回值为结果值，参数为原始值
 *
 *  @return 当前对象
 */
- (instancetype)lcs_calculate:(int(^)(int))block
{
    _result = block(_result);
    return  self;
}

@end
