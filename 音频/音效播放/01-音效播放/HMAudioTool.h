//
//  HMAudioTool.h
//  01-音效播放
//
//  Created by apple on 14/11/7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMAudioTool : NSObject
// 播放音效
// 传入需要 播放的音效文件名称
+ (void)playAudioWithFilename:(NSString  *)filename;

// 销毁音效
+ (void)disposeAudioWithFilename:(NSString  *)filename;
@end
