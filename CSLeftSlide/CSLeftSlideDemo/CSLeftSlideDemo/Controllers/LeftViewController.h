//
//  LeftViewController.h
//  CSLeftSlideDemo
//
//  Created by LCS on 16/2/11.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
@protocol LeftViewControllerDelegate <NSObject>

- (void)LeftViewControllerdidSelectRow:(LeftViewControllerRowType)LeftViewControllerRowType;

@end

@interface LeftViewController : UIViewController

@property (nonatomic, weak) id <LeftViewControllerDelegate> delegate;

@end
