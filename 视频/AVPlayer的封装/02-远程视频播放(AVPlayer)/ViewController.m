//
//  ViewController.m
//  02-远程视频播放(AVPlayer)
//
//  Created by apple on 15/12/18.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "ViewController.h"
#import "VideoPlayView.h"
#import "FullViewController.h"

@interface ViewController ()

@property (weak, nonatomic) VideoPlayView *playView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupVideoPlayView];
    
    [self.playView setUrlString:@"http://v1.mukewang.com/a45016f4-08d6-4277-abe6-bcfd5244c201/L.mp4"];
}

- (void)setupVideoPlayView
{
    VideoPlayView *playView = [VideoPlayView videoPlayView];
    playView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width * 9 / 16);
    [self.view addSubview:playView];
    self.playView = playView;
    playView.contrainerViewController = self;
}

@end
