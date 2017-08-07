//
//  ViewController.m
//  自适应TextView
//
//  Created by user on 2017/5/23.
//  Copyright © 2017年 user. All rights reserved.
//

#import "ViewController.h"
#import "InputTextView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    InputTextView *textView = [[NSBundle mainBundle] loadNibNamed:@"InputTextView" owner:nil options:nil].firstObject;
    textView.frame = CGRectMake(0, 100, 375, 44);
    [self.view addSubview:textView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
