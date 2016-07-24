//
//  ViewController.m
//  01-播放音乐(AVPlayer)
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

// 播放本地音乐
void test () {
    // 1.创建音乐资源
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"1201111234.mp3" withExtension:nil];
//    
//    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
//    
//    // 2.创建播放器
//    // _player = [AVPlayer playerWithURL:url];
//    _player = [AVPlayer playerWithPlayerItem:playerItem];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.player play];
    
    // 切换另外一首音乐
//    AVPlayerItem *nextPlayerItem = [AVPlayerItem playerItemWithURL:nil];
//    [self.player replaceCurrentItemWithPlayerItem:nextPlayerItem];
    
}

#pragma mark - 懒加载代码

- (AVPlayer *)player
{
    if (_player == nil) {
        
        // 1.创建音乐资源
        NSURL *url = [NSURL URLWithString:@"http://cc.stream.qqmusic.qq.com/C100003j8IiV1X8Oaw.m4a?fromtag=52"];
        
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
        
        // 2.创建播放器
       // _player = [AVPlayer playerWithURL:url];
        _player = [AVPlayer playerWithPlayerItem:playerItem];
    }
    return _player;
}

@end
