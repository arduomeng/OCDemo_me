//
//  ViewController.m
//  GIF制作
//
//  Created by user on 2017/8/7.
//  Copyright © 2017年 user. All rights reserved.
//

#import "ViewController.h"
#import "NSGif.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSGif shareInstance] createGIFfromURL:[[NSBundle mainBundle] URLForResource:@"video" withExtension:@"mp4"] withFrameCount:20 delayTime:0.1 loopCount:0 progress:^(float progress) {
        NSLog(@"progress : %f", progress);
    } success:^(NSURL *GifURL) {
        NSLog(@"GifURL : %@", GifURL.absoluteString);
    } failure:^(NSError *error) {
        NSLog(@"error : %@", error);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [NSGif shareInstance].isCancel = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
