//
//  ViewController.m
//  MobVista
//
//  Created by arduomeng on 16/9/7.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import "ViewController.h"
#import <MVSDK/MVSDK.h>
#import "UIImageView+WebCache.h"
#import "Constant.h"


@interface ViewController ()<MVNativeAdManagerDelegate>

@property (weak, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;
@property (nonatomic, strong) MVNativeAdManager *adManager;
@property (nonatomic, strong) MVWallAdManager *wallManager;

@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAdView];
    
    //加载广告
    [_adManager loadAds];
    
    //初始化应用墙
    [self setupWallAd];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)setupAdView{
    //模板
    MVTemplate *template1 = [MVTemplate templateWithType:MVAD_TEMPLATE_BIG_IMAGE adsNum:1];
//    MVTemplate *template2 = [MVTemplate templateWithType:MVAD_TEMPLATE_ONLY_ICON adsNum:10];
    NSArray *temArr = @[template1];
    
    //初始化unitId
    _adManager = [[MVNativeAdManager alloc] initWithUnitID:MainUnitID fbPlacementId:nil supportedTemplates:temArr autoCacheImage:YES adCategory:0 presentingViewController:self];
    
    _adManager.delegate = self;
    
}

#pragma mark MVNativeAdManagerDelegate

//Native load 成功回调后需要在如下方法中做相应操作
- (void)nativeAdsLoaded:(nullable NSArray *)nativeAds
{
    //回调成功，返回广告数据
    MVCampaign *campaign = nativeAds.firstObject;
    //设置图片
    [_adImageView setImageWithURL:[NSURL URLWithString:campaign.imageUrl]];
    //将广告注册到View上
    [_adManager registerViewForInteraction:self.adView withCampaign:campaign];
}
- (void)nativeAdsFailedToLoadWithError:(nonnull NSError *)error
{
    //回调失败，做相应的处理
    NSLog(@"%@", error);
}

//广告跳转过程：
- (void)nativeAdDidClick:(nonnull MVCampaign *)nativeAd
{
    //用户点击广告
}
- (void)nativeAdClickUrlWillStartToJump:(nonnull NSURL *)clickUrl
{
    //网址开始解析
}
- (void)nativeAdClickUrlDidJumpToUrl:(nonnull NSURL *)jumpUrl
{
    //跳转到一个新的网址
}
- (void)nativeAdClickUrlDidEndJump:(nullable NSURL *)finalUrl
                             error:(nullable NSError *)error
{
    //点击后跳转到的最终的url
}


- (void)setupWallAd
{
    //初始化
     _wallManager = [[MVWallAdManager alloc] initWithUnitID:WallUnitID presentingViewController:self];
    
    //将view设置为App Wall入口
    [_wallManager loadWallIconToView:self.giftImageView withDefaultIconImage:nil];
}

@end
