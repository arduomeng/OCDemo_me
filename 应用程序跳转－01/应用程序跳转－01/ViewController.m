//
//  ViewController.m
//  应用程序跳转－01
//
//  Created by LCS on 15/12/8.
//  Copyright (c) 2015年 LCS. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  打开02应用
 *
 *  @param sender
 */
- (IBAction)onClickTwoButton:(id)sender {
    
    //  获取application对象，
    UIApplication *app = [UIApplication sharedApplication];
    //  创建需要打开的应用程序的url，
    NSURL *url = [NSURL URLWithString:@"02://shouquan?myScheme=01"];
    //  应用application打开url
    if ([app canOpenURL:url]) {
        [app openURL:url];
    }else
    {
        NSLog(@"无法打开应用程序02");
    }
    
}
- (IBAction)onClickDetailButton:(id)sender {
    //  获取application对象，
    UIApplication *app = [UIApplication sharedApplication];
    //  创建需要打开的应用程序的url，
    NSURL *url = [NSURL URLWithString:@"02://detail?myScheme=01"];
    //  应用application打开url
    if ([app canOpenURL:url]) {
        [app openURL:url];
    }else
    {
        NSLog(@"无法打开应用程序02");
    }
}


@end
