//
//  WBDropdownMenu.h
//  56新浪微博01
//
//  Created by Mac OS X on 15/9/23.
//  Copyright (c) 2015年 Mac OS X. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MenuShowPositionL,
    MenuShowPositionC,
    MenuShowPositionR,
} MenuShowPosition;

@class WBDropdownMenu;

@protocol WBDropdownMenuDelegate <NSObject>
@optional
- (void) dropdownMenuDidmiss:(WBDropdownMenu *)dropdownMenu;
- (void) dropdownMenuDidshow:(WBDropdownMenu *)dropdownMenu;
@end

@interface WBDropdownMenu : UIView

+ (instancetype) dropdownMenu;

- (void) showFrom:(UIView*)view;
- (void) dismiss;

//内容
@property (nonatomic, weak) UIView *content;

//内容控制器
@property (nonatomic, strong) UIViewController *contentVc;

//代理
@property (nonatomic, weak) id <WBDropdownMenuDelegate> delegate;

#pragma mark 参数
// 内容与背景图片的间距
@property (nonatomic, assign) float kContentMarginU;
@property (nonatomic, assign) float kContentMarginL;
@property (nonatomic, assign) float kContentMarginD;
@property (nonatomic, assign) float kContentMarginR;
// 背景显示位置

@property (nonatomic, assign) MenuShowPosition position;

@end
