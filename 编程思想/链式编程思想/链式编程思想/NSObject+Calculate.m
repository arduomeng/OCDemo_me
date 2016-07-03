//
//  NSObject+Calculate.m
//  链式编程思想
//
//  Created by LCS on 16/6/30.
//  Copyright © 2016年 LCS. All rights reserved.


//  给NSObject 添加计算方法

#import "NSObject+Calculate.h"
#import "calculateManager.h"
@implementation NSObject (Calculate)

/**
 *  计算方法
 *
 *  @param block 所需要计算的内容
 *
 *  @return 计算结果
 */

+ (NSInteger)lcs_makeCalculate:(void(^)(calculateManager *))block
{
    // 创建计算管理者
    calculateManager *mgr = [[calculateManager alloc] init];
    // 将管理者作为block的参数传递进去，回调传递进来的block
    block(mgr);
    // 返回计算结果
    return mgr.result;
}

@end
