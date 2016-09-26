//
//  pickerView.m
//  事件传递
//
//  Created by LCS on 16/7/24.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "pickerView.h"

@interface pickerView ()

@property (nonatomic, weak) IBOutlet UIButton *backButton;

@end

@implementation pickerView



- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    // 判断点是否在按钮上
    CGPoint po = [self convertPoint:point toView:_backButton];
    
    if ([self.backButton pointInside:po withEvent:event]) {
        return self.backButton;
    }else{
        return [super hitTest:point withEvent:event];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s", __func__);
}

@end
