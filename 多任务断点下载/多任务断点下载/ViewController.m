//
//  ViewController.m
//  多任务断点下载
//
//  Created by arduomeng on 17/2/28.
//  Copyright © 2017年 arduomeng. All rights reserved.
//


/*
多任务下载过程参考AFNetworking
 CSDownloadManager：下载管理单例
 CSDownload：一个task任务对应一个CSDownload对象，负责管理该task
 */
#import "ViewController.h"
#import "CSDownloadManager.h"
#import "CSDownload.h"

#define fileURL1 @"http://120.25.226.186:32812/resources/videos/minion_01.mp4"
#define fileURL2 @"http://120.25.226.186:32812/resources/videos/minion_02.mp4"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIProgressView *progressView1;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView2;

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onclick1:(UIButton *)button {
    button.selected = !button.selected;
    
    [[CSDownloadManager shareInstance] downloadDataWithURL:[NSURL URLWithString:fileURL1] resume:button.selected progress:^(CGFloat progress) {
        _progressView1.progress = progress;
        NSLog(@"%@ progress : %f", fileURL1, progress);
    } status:^(CSDownloadStatus status) {
        [self handleStatus:status fileStr:fileURL1 button:button];
    }];
}
- (IBAction)onclick2:(UIButton *)button {
    button.selected = !button.selected;
    
    [[CSDownloadManager shareInstance] downloadDataWithURL:[NSURL URLWithString:fileURL2] resume:button.selected progress:^(CGFloat progress) {
        _progressView2.progress = progress;
        NSLog(@"%@ progress : %f", fileURL2, progress);
    } status:^(CSDownloadStatus status) {
        [self handleStatus:status fileStr:fileURL2 button:button];
    }];
}


- (void)handleStatus:(CSDownloadStatus)status fileStr:(NSString *)fileStr button:(UIButton *)button{
    switch (status) {
        case CSDownloadStatusCompleted:
            NSLog(@"%@ CSDownloadStatusCompleted", fileStr);
            button.hidden = YES;
            break;
        case CSDownloadStatusFailed:
            NSLog(@"%@ CSDownloadStatusFailed", fileStr);
            button.selected = NO;
            break;
        default:
            break;
    }
}

@end
