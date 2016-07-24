//
//  ViewController.m
//  04-播放视频(MPMoviePlayerViewController)
//
//  Created by xiaomage on 15/12/19.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()
/** 播放器 */
@property (nonatomic, strong) MPMoviePlayerViewController *playerVC;
@end

@implementation ViewController

- (IBAction)btnClick {
    
    // 弹出播放器,并播放视频
    [self presentViewController:self.playerVC animated:YES completion:nil];
}

- (MPMoviePlayerViewController *)playerVC
{
    if (_playerVC == nil) {
        
        // 1.创建视频的资源
        NSURL *url = [NSURL URLWithString:@"http://v1.mukewang.com/19954d8f-e2c2-4c0a-b8c1-a4c826b5ca8b/L.mp4"];
        
        // 2.创建播放器
        _playerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        
    }
    return _playerVC;
}

@end
