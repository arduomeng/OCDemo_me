//
//  ViewController.m
//  02-播放视频(AVPlayer)
//
//  Created by xiaomage on 15/12/19.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

/** 播放器 */
@property (nonatomic, strong) AVPlayer *player;

@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.player play];
}

- (AVPlayer *)player
{
    if (_player == nil) {
        
        // 1.加载视频资源
      //  NSURL *url = [[NSBundle mainBundle] URLForResource:@"xiaohuangren.mp4" withExtension:nil];
        
        NSURL *url = [NSURL URLWithString:@"http://v1.mukewang.com/19954d8f-e2c2-4c0a-b8c1-a4c826b5ca8b/L.mp4"];
        
        // 2.创建播放器
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        
        // 3.创建AVPlayerLayer
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        playerLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width * 9 / 16);
        [self.view.layer addSublayer:playerLayer];
        
    }
    return _player;
}


@end
