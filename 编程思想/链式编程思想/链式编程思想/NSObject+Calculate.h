//
//  NSObject+Calculate.h
//  链式编程思想
//
//  Created by LCS on 16/6/30.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "calculateManager.h"
@interface NSObject (Calculate)


+ (NSInteger)lcs_makeCalculate:(void(^)(calculateManager *))block;

@end
