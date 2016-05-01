//
//  ViewController.m
//  掉表情
//
//  Created by LCS on 16/4/2.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "ViewController.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ViewController ()

@property (nonatomic , strong) NSTimer *timer;

@end

@implementation ViewController
- (IBAction)startAnimation:(id)sender {
    _timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(createIcon) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}
- (IBAction)endAnimation:(id)sender {
    [_timer invalidate];
    _timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)createIcon  {
    UIImageView *image = [[UIImageView alloc] init];
    image.bounds = CGRectMake(0, 0, 50, 50);
    image.image = [UIImage imageNamed:@"d_aini"];
    
    CGFloat scale = arc4random_uniform(5);
    image.transform = CGAffineTransformScale(image.transform, 0.5 + scale / 10, 1);
    CGFloat translateX = arc4random_uniform(kScreenWidth);
    image.transform = CGAffineTransformMakeTranslation(translateX, 0 - image.bounds.size.height);
    translateX = arc4random_uniform(kScreenWidth);
    [UIView animateWithDuration:3 animations:^{
        
        image.transform = CGAffineTransformTranslate(image.transform, translateX, kScreenHeight);
    } completion:^(BOOL finished) {
        [image removeFromSuperview];
    }];
    
    [self.view addSubview:image];
}

@end
