//
//  ViewController.m
//  换肤
//
//  Created by xiaomage on 15/8/19.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "SkinTool.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;
@property (weak, nonatomic) IBOutlet UIImageView *heartImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rectImageView;

@end

@implementation ViewController

/*
 问题一:默认进来没有皮肤颜色
 
 问题二:没有记录用户选中皮肤颜色
 
 问题三:和美工沟通的问题
 
 问题四:多个控制器的换肤
 
 问题五:换肤的ImageView不要写在viewDidLoad方法
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self changeImages];
}
- (IBAction)changeToOrangeSkin {
    [SkinTool setSKinColor:@"orange"];
    
    [self changeImages];
}

- (IBAction)changeToBlueSkin {
    [SkinTool setSKinColor:@"blue"];
    
    [self changeImages];
}

- (IBAction)changeToRedSkin {
    [SkinTool setSKinColor:@"red"];
    
    [self changeImages];
}

- (IBAction)changeToGreenSkin {
    [SkinTool setSKinColor:@"green"];
    
    [self changeImages];
}

- (void)changeImages
{
    self.faceImageView.image = [SkinTool skinToolWithImageName:@"face"];
    self.heartImageView.image = [SkinTool skinToolWithImageName:@"heart"];
    self.rectImageView.image = [SkinTool skinToolWithImageName:@"rect"];
}

@end
