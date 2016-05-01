//
//  weiboWelcome.m
//  微博启动动画
//
//  Created by LCS on 16/3/27.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "weiboWelcome.h"

@interface weiboWelcome ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;


@end

@implementation weiboWelcome

//当控件被加到夫控件后调用
- (void)didMoveToSuperview{
    _icon.transform = CGAffineTransformTranslate(self.transform, 0, 100);
    _icon.alpha = 0;
    [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _icon.transform = CGAffineTransformIdentity;
        _icon.alpha= 1;
    } completion:^(BOOL finished) {
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}
@end
