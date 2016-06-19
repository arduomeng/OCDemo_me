//
//  ViewController.m
//  02-音乐播放
//
//  Created by apple on 14/11/7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "HMAudioTool.h"

@interface ViewController ()

// 播放
- (IBAction)playMusic:(id)sender;
// 暂停
- (IBAction)pauseMusic:(id)sender;
// 停止
- (IBAction)stopMusic:(id)sender;
// 下一首
- (IBAction)nextMusic:(id)sender;

// 保存所有的音乐
@property (nonatomic, strong) NSArray *musics;

// 记录当前播放音乐的索引
@property (nonatomic, assign) int  currentIndex;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)playMusic:(id)sender {
    
    [HMAudioTool playMusicWithFilename:self.musics[self.currentIndex]];
}

- (IBAction)pauseMusic:(id)sender {
    
    [HMAudioTool pauseMusicWithFilename:self.musics[self.currentIndex]];
}

- (IBAction)stopMusic:(id)sender {
    [HMAudioTool stopMusicWithFilename:self.musics[self.currentIndex]];
    
}

- (IBAction)nextMusic:(id)sender {
    // 下一首
    
    // 1.递增索引
    int nextIndex = self.currentIndex + 1;
    
    // 3.判断是否越界
    if (nextIndex >= self.musics.count) {
        nextIndex = 0;
    }
    NSLog(@"当前 %d  下一首 %d",  self.currentIndex, nextIndex);
    
    // 4.播放
    // 停止上一首播放
    [self stopMusic: nil];
    self.currentIndex = nextIndex;
    // 播放下一首
    [self playMusic:nil];
    
}


#pragma mark - 懒加载
- (NSArray *)musics
{
    if (!_musics) {
        _musics = @[@"最佳损友.mp3", @"心碎了无痕.mp3", @"瓦解.mp3", @"简单爱.mp3"];
    }
    return _musics;
}
@end
