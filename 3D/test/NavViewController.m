//
//  NavViewController.m
//  test
//
//  Created by 易彬 on 15/11/8.
//  Copyright © 2015年 易彬. All rights reserved.
//

#import "NavViewController.h"
#define SCREEN_W [[UIScreen mainScreen] bounds].size.width
#define SCREEN_H [[UIScreen mainScreen] bounds].size.height
@interface NavViewController ()

@end

@implementation NavViewController

#pragma mark - 懒加载
- (pageView *)pageControl
{
    if (_pageControl == nil)
    {
        _pageControl = [[[NSBundle mainBundle]loadNibNamed:@"pageView" owner:nil options:nil] lastObject];
    }
    return _pageControl;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pageControl.page.currentPage = 1;
    self.pageControl.frame = CGRectMake(0, SCREEN_H-20, SCREEN_W, 20);
    [self.view addSubview:self.pageControl];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changePage:) name:@"page" object:nil];
}


- (void)changePage:(NSNotification *)info
{
    if ([info.userInfo[@"title"] isEqualToString:@"客户中心"])
    {
        self.pageControl.page.currentPage = 0;
    }
    else if ([info.userInfo[@"title"] isEqualToString:@"滔滔鲜度柜"])
    {
        self.pageControl.page.currentPage = 1;
    }
    else if ([info.userInfo[@"title"] isEqualToString:@"服务网点"])
    {
        self.pageControl.page.currentPage = 2;
    }
}

@end
