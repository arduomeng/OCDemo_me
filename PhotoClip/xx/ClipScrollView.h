//
//  ClipScrollView.h
//  xx
//
//  Created by arduomeng on 16/11/16.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClipScrollView : UIScrollView

@property (nonatomic, strong) UIImage *image;

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;
- (void)beginClip;
- (UIImage *)getClipImage;
- (void)resetView;
@end
