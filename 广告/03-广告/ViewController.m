//
//  ViewController.m
//  03-广告
//
//  Created by xiaomage on 15/8/12.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//  AdMob SDK API

#import "ViewController.h"
#import <iAd/iAd.h>

@interface ViewController () <ADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerViewBottomCon;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

// 广告加载失败
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"%s", __func__);
}

// 即将加载广告
- (void)bannerViewWillLoadAd:(ADBannerView *)banner
{
    NSLog(@"%s", __func__);
}

// 广告已经加载
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    self.bannerViewBottomCon.constant = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}
// 广告退出
- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    NSLog(@"%s", __func__);
}

@end
