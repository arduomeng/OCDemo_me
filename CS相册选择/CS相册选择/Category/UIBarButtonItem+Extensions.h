//
//  UIBarButtonItem+Extensions.h
//  CSLeftSlideDemo
//
//  Created by LCS on 16/2/13.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extensions)

+ (UIBarButtonItem *)barButtonItemWithImage:(NSString *)image highLightImage:(NSString *)highImage target:(id)target action:(SEL)action;

@end
