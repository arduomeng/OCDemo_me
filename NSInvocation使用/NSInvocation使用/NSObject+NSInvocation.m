//
//  NSObject+NSInvocation.m
//  NSInvocation使用
//
//  Created by Apple on 16/4/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "NSObject+NSInvocation.h"

@implementation NSObject (NSInvocation)

- (id)performSelector:(SEL)selector withObjects:(NSArray *)params{
    
    //NSInvocation使用
    // 方法签名
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
    
    if (!signature) {
        // 异常的两种方式 NSException:程序奔溃退出 try catch:抛出异常程序继续执行
        // @throw [NSException exceptionWithName:@"NSObject+NSInvocation" reason:@"unrecognized selector sent to instance" userInfo:nil];
         [NSException raise:@"NSObject+NSInvocation" format:@"unrecognized selector sent to instance %@", NSStringFromSelector(selector)];
        
    }
    
    // NSInvocation : 利用NSInvocation对象包装一次方法的调用：(target， selector， param， return)
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.selector = selector;
    invocation.target = self;
    
    // 参数设置
    // 设置参数个数，MIN(方法需要的参数， 实际传入的参数)
    NSInteger paramsCount = signature.numberOfArguments - 2; //除self _cmd(默认的两个参数)外的参数
    paramsCount = MIN(paramsCount, params.count);
    for (int i= 0 ; i < paramsCount; i ++) {
        if ([params[i] isKindOfClass:[NSNull class]]) {
            continue;
        }
        NSString *param1 = params[i];
        [invocation setArgument:&param1 atIndex:2 + i];
    }
    
    // 调用方法
    [invocation invoke];
    
    // 获取返回值
    
    // [signature methodReturnLength]获得返回值的字节数
    if ([signature methodReturnLength]) {
        id returnValue = nil;
        [invocation getReturnValue:&returnValue];
        return returnValue;
    }
    
    return nil;
}

@end
