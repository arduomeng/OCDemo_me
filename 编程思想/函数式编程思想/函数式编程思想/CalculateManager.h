//
//  CalculateManager.h
//  函数式编程思想
//
//  Created by LCS on 16/7/1.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculateManager : NSObject

@property (nonatomic, assign) int result;

- (instancetype)lcs_calculate:(int(^)(int))block;

@end
