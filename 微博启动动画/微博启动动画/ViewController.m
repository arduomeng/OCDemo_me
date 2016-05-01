//
//  ViewController.m
//  微博启动动画
//
//  Created by LCS on 16/3/27.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "ViewController.h"
#import "weiboWelcome.h"
#import "composeViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    composeViewController *ctrl = [[composeViewController alloc] initWithNibName:@"composeViewController" bundle:nil];
    
    [self presentViewController:ctrl animated:YES completion:nil];
}

@end
