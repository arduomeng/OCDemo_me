//
//  ViewController.m
//  CSShapeLayer
//
//  Created by LCS on 16/3/25.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "ViewController.h"
#import "CSQQButton.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CSQQButton *qqButton = [[CSQQButton alloc] initWithFrame:CGRectMake(100, 100, 20, 20)];
    [self.view addSubview:qqButton];
    
}



@end
