//
//  ViewController.m
//  录音
//
//  Created by LCS on 16/5/28.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()

@property (nonatomic, strong) AVAudioRecorder *recoder;

@end

@implementation ViewController

- (AVAudioRecorder *)recoder{
    if (!_recoder) {
        // 1. 录音存放地址
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fileName = [filePath stringByAppendingPathComponent:@"luyin.caf"];
        NSURL *url = [[NSURL alloc] initWithString:fileName];
        
        // 2. 创建录音对象
        _recoder = [[AVAudioRecorder alloc] initWithURL:url settings:nil error:nil];
        
        // 3.准备录音
        [_recoder prepareToRecord];
    }
    return _recoder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)startRecode:(id)sender {
    
    // 4.开始录音
    [_recoder record];
}


- (IBAction)stopRecode:(id)sender {
    [_recoder stop];
}

@end
