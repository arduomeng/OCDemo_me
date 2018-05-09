//
//  UIFont+FontFit.m
//  Runtime字体适配
//
//  Created by user on 2018/5/8.
//  Copyright © 2018年 user. All rights reserved.
//

#import "UIFont+FontFit.h"
#import <objc/runtime.h>


#define MyUIScreen  375 // UI设计原型图的手机尺寸宽度(6), 6p的--414

@implementation UIFont (FontFit)

+ (void)load{
    Method new = class_getClassMethod([self class], @selector(adjustFont:));
    Method old = class_getClassMethod([self class], @selector(systemFontOfSize:));
    method_exchangeImplementations(new, old);
}

+ (UIFont *)adjustFont:(CGFloat)fontSize{
    UIFont *newFont = nil;
    newFont = [UIFont adjustFont:fontSize * [UIScreen mainScreen].bounds.size.width / MyUIScreen];
    return newFont;
}

@end
