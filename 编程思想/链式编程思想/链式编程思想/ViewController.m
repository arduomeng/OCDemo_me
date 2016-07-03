//
//  ViewController.m
//  链式编程思想
//
//  Created by LCS on 16/6/30.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+Calculate.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSInteger result =  [NSObject lcs_makeCalculate:^(calculateManager *mgr) {
        
        // mgr.add(5)
        /*
         该操作相当于执行下面的block
         ^(int num){
            _result += num;
            return self;
         };
         */
        
        // 通过.语法调用add方法
        mgr.add(5).add(6).add(7);
        
    }];
    
    NSLog(@"result = %ld", result);
    // Do any additional setup after loading the view, typically from a nib.
}


@end
