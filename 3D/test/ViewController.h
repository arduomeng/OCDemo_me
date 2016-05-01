//
//  ViewController.h
//  test
//
//  Created by 易彬 on 15/11/8.
//  Copyright © 2015年 易彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewOne.h"
#import "ViewTwo.h"
#import "ViewThree.h"

@interface ViewController : UIViewController

@property (assign, nonatomic) CGFloat start_touch_x;
@property (assign, nonatomic) CGFloat last_touch_x;
@property (assign, nonatomic) CGFloat angle_view_1;
@property (assign, nonatomic) CGFloat angle_view_2;
@property (assign, nonatomic) CGFloat angle_view_3;
@property (assign, nonatomic) NSUInteger nowIndex;
@property (assign, nonatomic) BOOL beginFlag;


@property (strong, nonatomic) ViewOne * one;
@property (strong, nonatomic) ViewTwo * two;
@property (strong, nonatomic) ViewThree * three;
@end

