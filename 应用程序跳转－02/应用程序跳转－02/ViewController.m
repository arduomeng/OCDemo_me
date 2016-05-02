//
//  ViewController.m
//  应用程序跳转－02
//
//  Created by LCS on 15/12/8.
//  Copyright (c) 2015年 LCS. All rights reserved.
//

#import "ViewController.h"
#import "ShouquanViewController.h"
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
- (IBAction)onClickOneButton:(id)sender {
    
    //  获取application对象，
    UIApplication *app = [UIApplication sharedApplication];
    //  创建需要打开的应用程序的url，
    NSURL *url = [NSURL URLWithString:@"01://"];
    //  应用application打开url
    if ([app canOpenURL:url]) {
        [app openURL:url];
    }else
    {
        NSLog(@"无法打开应用程序01");
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSString *)sender
{
    if ([segue.destinationViewController isKindOfClass:[ShouquanViewController class]]) {
        ShouquanViewController *vc = [segue destinationViewController];
        vc.callScheme = sender;
    }
    
}

@end
