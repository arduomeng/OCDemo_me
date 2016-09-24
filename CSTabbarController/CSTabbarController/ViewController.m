//
//  ViewController.m
//  CSTabbarController
//
//  Created by LCS on 16/8/1.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "ViewController.h"
#import "CSTabbarController.h"
#import "CSTableViewController.h"
@interface ViewController ()
@property (nonatomic, strong) CSTabbarController *csTabbarVC;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CSTableViewController *vc1 = [[CSTableViewController alloc] init];
    vc1.title = @"xx";
    
    CSTableViewController *vc2 = [[CSTableViewController alloc] init];
    vc2.title = @"ee";
    
    CSTableViewController *vc3 = [[CSTableViewController alloc] init];
    vc3.title = @"qq";
    
    _csTabbarVC = [[CSTabbarController alloc] initWithControllerArr:@[vc1, vc2, vc3] TitleArr:@[@"xx", @"oo", @"qq"]];
    
    [self addChildViewController:_csTabbarVC];
    [self.view addSubview:_csTabbarVC.view];
}



@end
