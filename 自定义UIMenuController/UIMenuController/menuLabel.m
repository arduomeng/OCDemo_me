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
    
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

// YES 代表支持这种操作
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return NO;
}



@end
