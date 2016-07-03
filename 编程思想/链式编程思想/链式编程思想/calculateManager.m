//
//  calculateManager.m
//  链式编程思想
//
//  Created by LCS on 16/6/30.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "calculateManager.h"

@implementation calculateManager

/**
 *  返回一个block
    block的类型 ： 返回值为instancetype即calculateManager * 参数为int类型的block
 */
- (calculateManager *(^)(int))add{
    return ^(int num){
        _result += num;
        return self;
    };
}

@end
