//
//  CSLabel.m
//  网易新闻频道
//
//  Created by LCS on 16/4/7.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "CSLabel.h"

//初始颜色
#define CSRedS 0
#define CSGreenS 0
#define CSBlueS 0
//变化颜色
#define CSRedE 1
#define CSGreenE 0
#define CSBlueE 0

@implementation CSLabel

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor colorWithRed:CSRedS green:CSGreenS blue:CSBlueS alpha:1];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)setScale:(CGFloat)scale{
    
    CGFloat red = CSRedS + (CSRedE - CSRedS) * scale;
    CGFloat green = CSGreenS + (CSGreenE - CSGreenS) * scale;
    CGFloat blue = CSBlueS + (CSBlueE - CSBlueS) * scale;
    
    //设置label的变化
    self.textColor = [UIColor colorWithRed:red green:green blue:blue - scale alpha:1];
    //self.transform = CGAffineTransformMakeScale(1 + scale / 2, 1 + scale / 2);
}

@end
