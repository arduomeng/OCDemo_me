//
//  ViewController.m
//  03-MPMovieController(播放视频)
//
//  Created by xiaomage on 15/12/19.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()
/** 播放器 */
@property (nonatomic, strong) MPMoviePlayerController *playerController;


@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.playerController play];
    
}

//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration

//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
//{
//    
//}

- (MPMoviePlayerController *)playerController
{
    if (_playerController == nil) {
        
        // 1.创建视频的资源
        NSURL *url = [NSURL URLWithString:@"http://v1.mukewang.com/19954d8f-e2c2-4c0a-b8c1-a4c826b5ca8b/L.mp4"];
        
        // 2.创建播放器
        _playerController = [[MPMoviePlayerController alloc] initWithContentURL:url];
        _playerController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width * 9 / 16);
        [self.view addSubview:_playerController.view];
        
        // 3.取消工具栏
        _playerController.controlStyle = MPMovieControlStyleDefault;
        
    }
    return _playerController;
}

@end
