//
//  CSVideoPlayView.h
//  VideoEdit
//
//  Created by arduomeng on 16/11/30.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVPlayerItem;
@interface CSVideoPlayView : UIView

@property (nonatomic, copy)  NSURL *url;
@property (nonatomic, strong) AVPlayerItem *outerPlayerItem;

/* 包含在哪一个控制器中 */
@property (nonatomic, weak) UIViewController *contrainerViewController;

@end
