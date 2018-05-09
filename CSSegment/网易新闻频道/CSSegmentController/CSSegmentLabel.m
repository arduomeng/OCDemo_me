//
//  CSSegmentLabel.m
//  网易新闻频道
//
//  Created by LCS on 16/4/7.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "CSSegmentLabel.h"

@implementation CSSegmentLabel

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.textAlignment = NSTextAlignmentCenter;
        self.userInteractionEnabled = YES;
        
    }
    return self;
}
@end
