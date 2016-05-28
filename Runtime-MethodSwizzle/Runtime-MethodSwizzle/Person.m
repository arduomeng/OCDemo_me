//
//  Person.m
//  Runtime-MethodSwizzle
//
//  Created by LCS on 16/5/2.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)run{
    NSLog(@"run");
    
    // 由于方法交换了，此处实际上调用的是eat
    [self run];
}
- (void)eat{
    NSLog(@"eat");
}

@end
