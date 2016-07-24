//
//  ViewController.m
//  05-播放远程视频(AVPlayerViewController)
//
//  Created by xiaomage on 15/12/19.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "ViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
/** 播放器 */
@property (nonatomic, strong) AVPlayerViewController *playerVC;
@end

@implementation ViewController

- (IBAction)play {
    
    [self presentViewController:self.playerVC animated:YES completion:nil];
}

- (AVPlayerViewController *)playerVC
{
    if (_playerVC == nil) {
        
        NSURL *url = [NSURL URLWithString:@"http://v1.mukewang.com/19954d8f-e2c2-4c0a-b8c1-a4c826b5ca8b/L.mp4"];
        AVPlayerItem *playItem = [AVPlayerItem playerItemWithURL:url];
        AVPlayer *player = [AVPlayer playerWithPlayerItem:playItem];
        
        _playerVC = [[AVPlayerViewController alloc] init];
        _playerVC.player = player;
    }
    return _playerVC;
}


@end
