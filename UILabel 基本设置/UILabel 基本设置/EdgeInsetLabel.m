//
//  EdgeInsetLabel.m
//  UILabel 基本设置
//
//  Created by user on 2017/8/4.
//  Copyright © 2017年 user. All rights reserved.
//

#import "EdgeInsetLabel.h"

@implementation EdgeInsetLabel

- (void)drawTextInRect:(CGRect)rect {
    
    CGFloat offset = self.font.pointSize;
    UIEdgeInsets insets = {0, 15, 0, 15};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
