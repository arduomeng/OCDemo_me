//
//  composeButton.m
//  微博启动动画
//
//  Created by LCS on 16/3/28.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "composeButton.h"
#define kRatio 0.8
@implementation composeButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    self.imageView.contentMode = UIViewContentModeCenter;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor blackColor];
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat h = self.bounds.size.height * kRatio;
    CGFloat w = self.bounds.size.width;
    self.imageView.frame = CGRectMake(x, y, w, h);
    self.titleLabel.frame = CGRectMake(0, h, w, self.bounds.size.height - h);
}

- (void)setHighlighted:(BOOL)highlighted{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.transform = CGAffineTransformScale(self.transform, 1.5, 1.5);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.5 animations:^{
       self.transform = CGAffineTransformScale(self.transform, 1.5, 1.5);
        self.alpha = 0;
    }];
}

@end
