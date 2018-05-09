//
//  CSSegmentController.h
//  网易新闻频道
//
//  Created by user on 2018/4/16.
//  Copyright © 2018年 LCS. All rights reserved.
//

#import <UIKit/UIKit.h>

// 标题被点击或者内容滚动完成，会发出这个通知，监听这个通知，可以做自己想要做的事情，比如加载数据
static NSString * const CSTitleClickOrScrollDidFinshNoti = @"CSTitleClickOrScrollDidFinshNoti";

// 颜色渐变样式
typedef enum : NSUInteger {
    CSTitleColorGradientStyleRGB , // RGB:默认RGB样式
    CSTitleColorGradientStyleFill, // 填充
} CSTitleColorGradientStyle;

// 导航条高度
static CGFloat const CSNavBarH = 64;

// 标题滚动视图的高度
static CGFloat const CSTitleScrollViewH = 44;

// 标题宽度
static CGFloat const CSTitleViewW = 100;

// 标题缩放比例
static CGFloat const CSTitleTransformScale = 1.3;

// 下划线默认高度
static CGFloat const CSUnderLineH = 2;

@interface CSSegmentController : UIViewController

/**
 根据角标，选中对应的控制器
 */
@property (nonatomic, assign) NSInteger selectIndex;

- (instancetype)initWithControllerArr:(NSArray *)controllerArr TitleArr:(NSArray *)titleArr;

// 配置方法
- (void)setUpTitleScale:(void(^)(CGFloat *titleScale))titleScaleBlock;
- (void)setUpTitleEffect:(void(^)(UIColor * __strong*titleScrollViewColor,UIColor * __strong*norColor,UIColor * __strong*selColor,UIFont * __strong*titleFont,CGFloat *titleHeight,CGFloat *titleWidth))titleEffectBlock;
- (void)setUpTitleColorGradient;
- (void)setUpUnderLineEffect:(void(^)(BOOL *isDelayScroll,CGFloat *underLineH,UIColor * __strong*underLineColor,BOOL *isUnderLineEqualTitleWidth))underLineBlock;
@end
