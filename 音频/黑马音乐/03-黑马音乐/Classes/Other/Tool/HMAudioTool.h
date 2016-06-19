//
//  HMAudioTool.h
//  01-音效播放
//
//  Created by apple on 14/11/7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface HMAudioTool : NSObject


// 播放音效
// 传入需要 播放的音效文件名称
+ (void)playAudioWithFilename:(NSString  *)filename;

// 销毁音效
+ (void)disposeAudioWithFilename:(NSString  *)filename;

// 根据音乐文件名称播放音乐
+ (AVAudioPlayer *)playMusicWithFilename:(NSString  *)filename;

// 根据音乐文件名称暂停音乐
+ (void)pauseMusicWithFilename:(NSString  *)filename;

// 根据音乐文件名称停止音乐
+ (void)stopMusicWithFilename:(NSString  *)filename;
@end
