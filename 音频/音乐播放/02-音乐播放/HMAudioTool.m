//
//  HMAudioTool.m
//  01-音效播放
//
//  Created by apple on 14/11/7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMAudioTool.h"
#import <AVFoundation/AVFoundation.h>

@implementation HMAudioTool

// 一个soundID对应一个音效
static NSMutableDictionary *_soundIDs;
// 一个player对应一个音乐
static NSMutableDictionary *_players;

+ (NSMutableDictionary *)soundIDs
{
    if (!_soundIDs) {
        _soundIDs = [NSMutableDictionary dictionary];
    }
    return _soundIDs;
}
+ (NSMutableDictionary *)players
{
    if (!_players) {
        _players = [NSMutableDictionary dictionary];
    }
    return _players;
}

+ (void)playAudioWithFilename:(NSString *)filename
{

    // 0.判断文件名是否为nil
    if (filename == nil) {
        return;
    }
    
    // 1.从字典中取出音效ID
    SystemSoundID soundID = [[self soundIDs][filename] unsignedIntValue];
    
    // 判断音效ID是否为nil
    if (!soundID) {
        NSLog(@"创建新的soundID");
        
        // 音效ID为nil
        // 根据文件名称加载音效URL
        NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        
        // 判断url是否为nil
        if (!url) {
            return;
        }
        
        // 创建音效ID
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
        
        // 将音效ID添加到字典中
        [self soundIDs][filename] = @(soundID);
    }
    // 播放音效
    AudioServicesPlaySystemSound(soundID);
}

+ (void)disposeAudioWithFilename:(NSString *)filename
{
    // 0.判断文件名是否为nil
    if (filename == nil) {
        return;
    }
    
    // 1.从字典中取出音效ID
    SystemSoundID soundID = [[self soundIDs][filename] unsignedIntValue];
    
    if (soundID) {
        // 2.销毁音效ID
        AudioServicesDisposeSystemSoundID(soundID);
        
        // 3.从字典中移除已经销毁的音效ID
        [[self soundIDs] removeObjectForKey:filename];
    }
  
}

// 根据音乐文件名称播放音乐
+ (void)playMusicWithFilename:(NSString  *)filename
{
    // 0.判断文件名是否为nil
    if (filename == nil) {
        return;
    }
    
    // 1.从字典中取出播放器
    AVAudioPlayer *player = [self players][filename];
    
    // 2.判断播放器是否为nil
    if (!player) {
        NSLog(@"创建新的播放器");
        
        // 2.1根据文件名称加载音效URL
        NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        
        // 2.2判断url是否为nil
        if (!url) {
            return;
        }
        
        // 2.3创建播放器
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        // 2.4准备播放
        if(![player prepareToPlay])
        {
            return;
        }
        // 允许快进
        player.enableRate = YES;
        player.rate = 1;
        
        // 2.5将播放器添加到字典中
        [self players][filename] = player;
        
    }
    // 3.播放音乐
    if (!player.playing)
    {
        [player play];
    }
   
}

// 根据音乐文件名称暂停音乐
+ (void)pauseMusicWithFilename:(NSString  *)filename
{
    // 0.判断文件名是否为nil
    if (filename == nil) {
        return;
    }
    
    // 1.从字典中取出播放器
    AVAudioPlayer *player = [self players][filename];

    // 2.判断播放器是否存在
    if(player)
    {
        // 2.1判断是否正在播放
        if (player.playing)
        {
            // 暂停
            [player pause];
        }
    }
    
}

// 根据音乐文件名称停止音乐
+ (void)stopMusicWithFilename:(NSString  *)filename
{
    // 0.判断文件名是否为nil
    if (filename == nil) {
        return;
    }
    
    // 1.从字典中取出播放器
    AVAudioPlayer *player = [self players][filename];

    // 2.判断播放器是否为nil
    if (player) {
        // 2.1停止播放
        [player stop];
#warning 注意当播放器stop之后播放器就失效了，需要重新创建
        // 2.3从字典中移除播放器
        [[self players] removeObjectForKey:filename];
    }
}
@end
