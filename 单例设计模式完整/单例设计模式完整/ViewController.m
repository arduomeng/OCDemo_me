//
//  ViewController.m
//  单例设计模式完整
//
//  Created by LCS on 16/4/9.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "ViewController.h"
#import "person.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    person *p2 = [person shareInstance];
    person *p1 = [[person alloc] init];
    
    NSLog(@" %p, %p", p1, p2);
}

@end
