//
//  ViewController.m
//  程序崩溃情况
//
//  Created by Apple on 16/4/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 异常的两种方式 NSException:程序奔溃退出 try catch:抛出异常程序继续执行
    
    // @throw [NSException exceptionWithName:@"NSObject+NSInvocation" reason:@"unrecognized selector sent to instance" userInfo:nil];
    // [NSException raise:@"NSObject+NSInvocation" format:@"unrecognized selector sent to instance %@", NSStringFromSelector(selector)];
    
    @try {
        NSLog(@"try start");
        
        NSArray *array = @[@1];
        array[5];
        
        NSLog(@"try end");
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
        NSLog(@"%@", [exception callStackSymbols]);
    } @finally {
        NSLog(@"finally");
    }
    
    NSLog(@"end");
    
    
}

@end
