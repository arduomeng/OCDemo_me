//
//  ViewController.m
//  视频边下边播
//
//  Created by arduomeng on 17/2/15.
//  Copyright © 2017年 arduomeng. All rights reserved.
//

#import "ViewController.h"
#import "CSVideoPlayView.h"

//#define videoAddress @"http://v1.mukewang.com/a45016f4-08d6-4277-abe6-bcfd5244c201/L.mp4"
#define videoAddress @"http://120.25.226.186:32812/resources/videos/minion_01.mp4"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *mainVideoView;
@property (nonatomic, strong) CSVideoPlayView *videoPlayView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _videoPlayView = [[[NSBundle mainBundle] loadNibNamed:@"CSVideoPlayView" owner:nil options:nil] lastObject];
    _videoPlayView.contrainerViewController = self;
    
    [self.mainVideoView addSubview:_videoPlayView];
    
    NSURL *url = [NSURL URLWithString:videoAddress];
    _videoPlayView.url = url;
    
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    _videoPlayView.frame = _mainVideoView.bounds;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
