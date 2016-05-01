//
//  NSObject+NSInvocation.h
//  NSInvocation使用
//
//  Created by Apple on 16/4/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NSInvocation)

- (id)performSelector:(SEL)selector withObjects:(NSArray *)params;

@end
