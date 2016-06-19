//
//  ViewController.m
//  01-音效播放
//
//  Created by apple on 14/11/7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "HMAudioTool.h"

@interface ViewController ()
@property (nonatomic, assign) SystemSoundID soundID;


@end

@implementation ViewController

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s", __func__);
    
    
    // 利用AudioServicesPlaySystemSound播放音乐, 但是注意: 真实开发中不建议使用该函数播放音乐
    [HMAudioTool playAudioWithFilename:@"normal.aac"];

}

// 接收到内存警告
- (void)didReceiveMemoryWarning
{
    [HMAudioTool disposeAudioWithFilename:@"buyao.wav"];
}

@end
