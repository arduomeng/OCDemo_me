//
//  Person.m
//  04-响应式编程思想
//
//  Created by xiaomage on 15/10/25.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "Person.h"

@implementation Person
- (void)setName:(NSString *)name
{
    _name = [NSString stringWithFormat:@"%@aaaa",name];
}
@end
