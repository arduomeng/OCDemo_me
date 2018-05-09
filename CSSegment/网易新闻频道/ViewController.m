//
//  ViewController.m
//  网易新闻频道
//
//  Created by LCS on 16/4/6.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "ViewController.h"
#import "CSSegmentController.h"
#import "CSTableViewController.h"

@interface ViewController ()

@property (strong, nonatomic) CSSegmentController *segmentCon;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    UIViewController *vc = [[CSTableViewController alloc] init];
    vc.title = @"头条";
    UIViewController *vc2 = [[CSTableViewController alloc] init];
    vc2.title = @"财经";
    UIViewController *vc3 = [[CSTableViewController alloc] init];
    vc3.title = @"娱乐";
    UIViewController *vc4 = [[CSTableViewController alloc] init];
    vc4.title = @"要闻";
    UIViewController *vc5 = [[CSTableViewController alloc] init];
    vc5.title = @"科技";
    UIViewController *vc6 = [[CSTableViewController alloc] init];
    vc6.title = @"段子";
    UIViewController *vc7 = [[CSTableViewController alloc] init];
    vc7.title = @"故事";
    UIViewController *vc8 = [[CSTableViewController alloc] init];
    vc8.title = @"股市";
    
    _segmentCon = [[CSSegmentController alloc] initWithControllerArr:@[vc, vc2, vc3, vc4, vc5, vc6, vc7, vc8] TitleArr:@[@"头条", @"财经财", @"娱乐", @"要闻", @"科技科技", @"段子", @"故事", @"股市"]];
    [self addChildViewController:_segmentCon];
    
    // 初始化
    [_segmentCon setUpTitleScale:^(CGFloat *titleScale) {
        *titleScale = 1.3;
    }];
    [_segmentCon setUpTitleEffect:^(UIColor *__strong *titleScrollViewColor, UIColor *__strong *norColor, UIColor *__strong *selColor, UIFont *__strong *titleFont, CGFloat *titleHeight, CGFloat *titleWidth) {
        *titleScrollViewColor = [UIColor whiteColor];
        *norColor = [UIColor blackColor];
        *selColor = [UIColor redColor];

        *titleFont = [UIFont systemFontOfSize:14];
        *titleHeight = 44;
        *titleWidth = 80;
    }];
    [_segmentCon setUpTitleColorGradient];
    [_segmentCon setUpUnderLineEffect:^(BOOL *isDelayScroll, CGFloat *underLineH, UIColor *__strong *underLineColor, BOOL *isUnderLineEqualTitleWidth) {

    }];
    
    [self.view addSubview:_segmentCon.view];
    
    _segmentCon.selectIndex = 0;
}


@end
