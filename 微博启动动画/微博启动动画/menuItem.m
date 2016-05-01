//
//  menuItem.m
//  微博启动动画
//
//  Created by LCS on 16/3/28.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "menuItem.h"

@implementation menuItem

+ (instancetype)menuItemWithImage:(NSString *)image title:(NSString *)title{
    menuItem *item = [[menuItem alloc] init];
    item.image = [UIImage imageNamed:image];
    item.title = title;
    return item;
}

@end
