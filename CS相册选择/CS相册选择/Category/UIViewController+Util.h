//
//  UIViewController+Util.h
//  CS相册选择
//
//  Created by arduomeng on 16/11/7.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Util)

+(instancetype) initFromStoryboard:(Class) aClass;

- (void)containerAddChildViewController:(UIViewController *)childViewController parentView:(UIView *)view;

- (void)containerAddChildViewController:(UIViewController *)childViewController toContainerView:(UIView *)view useAutolayout:(BOOL)autolayout;

- (void)containerAddChildViewController:(UIViewController *)childViewController toContainerView:(UIView *)view;

- (void)containerAddChildViewController:(UIViewController *)childViewController;

- (void)containerRemoveChildViewController:(UIViewController *)childViewController;


@end
