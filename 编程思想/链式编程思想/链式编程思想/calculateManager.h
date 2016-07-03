//
//  calculateManager.h
//  链式编程思想
//
//  Created by LCS on 16/6/30.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface calculateManager : NSObject

@property (nonatomic, assign) NSInteger result;

- (calculateManager *(^)(int))add;

@end
