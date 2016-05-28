//
//  menuLabel.m
//  UIMenuController
//
//  Created by Apple on 16/5/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "menuLabel.h"

@implementation menuLabel

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setUp];
    }
    return  self;
}

- (void)awakeFromNib{
    [self setUp];
}

- (void)setUp{
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelOnclick)];
    [self addGestureRecognizer:tap];
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

// YES 代表支持这种操作
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(cut:) || action == @selector(copy:) || action == @selector(paste:)) {
        return YES;
    }
    return NO;
}

// 实现 需要相应的方法 sender : menuController
- (void)copy:(id)sender{
    // 将文字复制到粘贴板
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = self.text;
}

- (void)cut:(id)sender{
    [self copy:sender];
    
    self.text = nil;
    
}

- (void)paste:(id)sender{
    
    
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    self.text = board.string;
    
}

- (void)labelOnclick{
    // 1.label成为第一响应者
    [self becomeFirstResponder];
    
    // 2.显示menuController
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:self.frame inView:self.superview];
    
    [menu setMenuVisible:YES animated:YES];
}

@end
