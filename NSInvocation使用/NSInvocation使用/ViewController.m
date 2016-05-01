//
//  ViewController.m
//  NSInvocation使用
//
//  Created by Apple on 16/4/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+NSInvocation.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //多值参数调用
    [self performSelector:@selector(function) withObjects:nil];
    [self performSelector:@selector(functionWithParam1:) withObjects:@[@"param1"]];
    [self performSelector:@selector(functionWithParam1:param2:) withObjects:@[@"param1", @"param2"]];
    NSString *returnValue = [self performSelector:@selector(functionWithParam1:param2:param3:) withObjects:@[@"param1", [NSNull null],@"param3"]];
    NSLog(@"%@", returnValue);
    
   
}

- (void)function{
    NSLog(@"%s", __func__);
}

- (void)functionWithParam1:(NSString *)param1{
    
    NSLog(@"%s %@", __func__, param1);
}

- (void)functionWithParam1:(NSString *)param1 param2:(NSString *)param2{
    NSLog(@"%s %@ %@", __func__, param1,param2);
}

- (NSString *)functionWithParam1:(NSString *)param1 param2:(NSString *)param2 param3:(NSString *)param3{
    NSLog(@"%s %@ %@ %@", __func__, param1,param2,param3);
    return @"functionWithParam1:param2:param3:";
}

@end
