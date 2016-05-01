//
//  composeViewController.m
//  微博启动动画
//
//  Created by LCS on 16/3/28.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "composeViewController.h"
#import "composeButton.h"
#import "menuItem.h"
#define kMenuItemY 300
@interface composeViewController ()

@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation composeViewController

static int btnIndex = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _btns = [NSMutableArray array];
    
    //初始化按钮
    [self setUp];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(addAnimation) userInfo:nil repeats:YES];
    
}


- (void)addAnimation{
    
    if (btnIndex >= 6) {
        [_timer invalidate];
        return;
    }
    composeButton *btn = _btns[btnIndex];
    
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        btn.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    
    btnIndex++;
}

- (void)setUp{
    
    //初始化模型数组
    menuItem *item1 = [menuItem menuItemWithImage:@"tabbar_compose_camera" title:@"相机"];
    menuItem *item2 = [menuItem menuItemWithImage:@"tabbar_compose_idea" title:@"想法"];
    menuItem *item3 = [menuItem menuItemWithImage:@"tabbar_compose_lbs" title:@"留言"];
    menuItem *item4 = [menuItem menuItemWithImage:@"tabbar_compose_more" title:@"更多"];
    menuItem *item5 = [menuItem menuItemWithImage:@"tabbar_compose_photo" title:@"图片"];
    menuItem *item6 = [menuItem menuItemWithImage:@"tabbar_compose_review" title:@"浏览"];
    _menuItems = @[item1, item2, item3, item4, item5, item6 ];
    
    int wh = 100;
    int cols = 3;
    
    float marginX = ([UIScreen mainScreen].bounds.size.width - cols * wh ) / (cols + 1);
    float marginY = 20;
    
    int counts = 6;
    
    for (int i = 0; i < counts; i ++) {
        composeButton *btn = [composeButton buttonWithType:UIButtonTypeCustom];
        menuItem *item = _menuItems[i];
        [btn setImage:item.image forState:UIControlStateNormal];
        [btn setTitle:item.title forState:UIControlStateNormal];
        [_btns addObject:btn];
        
        //计算九宫格
        int col = i % cols;
        int row = i / cols;
        btn.frame = CGRectMake(marginX + (wh + marginX) * col, kMenuItemY + (marginY + wh) * row, wh, wh);
        
        btn.transform = CGAffineTransformTranslate(btn.transform, 0, [UIScreen mainScreen].bounds.size.height);
        
        [self.view addSubview:btn];
    }
    
}


@end
