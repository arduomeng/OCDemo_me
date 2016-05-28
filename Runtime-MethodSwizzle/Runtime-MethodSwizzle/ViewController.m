//
//  ViewController.m
//  Runtime-MethodSwizzle
//
//  Created by LCS on 16/5/2.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import <objc/runtime.h>
@interface ViewController ()

@end

@implementation ViewController

/*
 * 作用：可以将一些系统自带的方法，交换成自定义方法，执行一些特定的操作。执行完毕后在调回系统的方法
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Person *p = [[Person alloc] init];
    // run和eat方法交换
    Method m1 = class_getInstanceMethod([p class], @selector(run));
    Method m2 = class_getInstanceMethod([p class], @selector(eat));
    method_exchangeImplementations(m1, m2);
    
    // 拦截eat的调用，执行自定义操作run，执行完后，调回eat操作
    [p eat];
}



@end
