//
//  UIImage+Extension.h
//  xx
//
//  Created by arduomeng on 16/11/16.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+ (UIImage *)imageWithColor:(UIColor *)color;

//  拉伸图片
+ (UIImage *)strechImage:(NSString *)imageName;

//  缩放图片
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

@end
