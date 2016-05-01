//
//  menuItem.h
//  微博启动动画
//
//  Created by LCS on 16/3/28.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface menuItem : NSObject

@property (nonatomic, strong)  UIImage *image;
@property (nonatomic, copy)    NSString *title;

+ (instancetype)menuItemWithImage:(NSString *)image title:(NSString *)title;

@end
