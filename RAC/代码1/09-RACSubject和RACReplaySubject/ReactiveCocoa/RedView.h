//
//  RedView.h
//  ReactiveCocoa
//
//  Created by xiaomage on 15/10/25.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GlobeHeader.h"

@interface RedView : UIView

@property (nonatomic, strong) RACSubject *btnClickSignal;

@end
