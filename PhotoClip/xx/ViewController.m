//
//  ViewController.m
//  xx
//
//  Created by arduomeng on 16/11/16.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import "ViewController.h"
#import "ClipView.h"
@interface ViewController ()
@property (strong, nonatomic) ClipView *clipView;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _clipView = [[ClipView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width) image:[UIImage imageNamed:@"pic2"]];
    [self.view addSubview:_clipView];
    
}
- (IBAction)resetOnclick:(id)sender {
    [_clipView resetView];
}

- (IBAction)clipOnclick:(id)sender {
    [_clipView beginClip];
}
- (IBAction)comfirmOnclick:(id)sender {
    UIImage *image = [_clipView getClipImage];
    _previewImageView.image = image;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
