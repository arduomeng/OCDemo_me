//
//  UIImage+Extension.m
//  xx
//
//  Created by arduomeng on 16/11/16.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGFloat imageW = 100;
    CGFloat imageH = 100;
    // 1.开启基于位图的图形上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageW, imageH), NO, 0.0);
    
    // 2.画一个color颜色的矩形框
    [color set];
    UIRectFill(CGRectMake(0, 0, imageW, imageH));
    
    // 3.拿到图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)strechImage:(NSString *)imageName
{
    UIImage *img = [UIImage imageNamed:imageName];
    img = [img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
    return img;
}

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    //  用一个固定大小的size
    UIGraphicsBeginImageContext(size);
    //    把图片按比例放在这里面
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    //    再取得当前图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
