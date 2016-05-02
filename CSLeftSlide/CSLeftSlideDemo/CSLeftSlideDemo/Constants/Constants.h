//
//  Constants.h
//  CSLeftSlideDemo
//
//  Created by LCS on 16/2/13.
//  Copyright © 2016年 LCS. All rights reserved.
//

#ifndef Constants_h
#define Constants_h



#define kLeftViewH [UIScreen mainScreen].bounds.size.height
#define kLeftViewW ([UIScreen mainScreen].bounds.size.width * 0.7)
#define kScale 0.8
#define kDuration 0.2
#define kcoverTag 3344

#define kNotificationLeftSlide @"kNotificationLeftSlide"

typedef enum {
    LeftViewControllerRowTypeOne,
    LeftViewControllerRowTypeTwo,
    LeftViewControllerRowTypeThree
}LeftViewControllerRowType;

#endif /* Constants_h */
