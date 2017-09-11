//
//  WBDropdownMenu.m
//  56新浪微博01
//
//  Created by Mac OS X on 15/9/23.
//  Copyright (c) 2015年 Mac OS X. All rights reserved.
//

#import "WBDropdownMenu.h"
#import "UIView+Extensions.h"




@interface WBDropdownMenu ()

//灰色图片Dropdown
@property (nonatomic, weak) UIImageView *containerView;

@end

@implementation WBDropdownMenu

- (UIImageView *)containerView
{
    if (_containerView == nil) {
        
        UIImageView *dropdownMenu = [[UIImageView alloc] init];
        dropdownMenu.image = [UIImage imageNamed:@"bg_sort_music-"];
        //图片的最大宽度
//        dropdownMenu.width = 217;
//        dropdownMenu.height = 300;
        //UIIMageView 默认不能和用户交互，所以添加到它上面的子控件也不能交互。
        dropdownMenu.userInteractionEnabled = YES;
        //先将局部对象dropdownMenu加到self中，再用弱指针指向才可以，否则函数结束，对象也就销毁了。
        [self addSubview:dropdownMenu];
        _containerView = dropdownMenu;
        
    }
    return _containerView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //添加蒙板
        self.backgroundColor = [UIColor clearColor];
        
        //添加灰色控件
        [self addSubview:self.containerView];
        
    }
    
    return self;
    
}

+ (instancetype) dropdownMenu
{
    return [[self alloc] init];
}

- (void)setContent:(UIView *)content
{
    _content = content;
    
    //调整内容位置
    content.x = self.kContentMarginL;
    content.y = self.kContentMarginU;
    
    //调整内容的宽度
    self.containerView.width = CGRectGetMaxX(content.frame) + self.kContentMarginR;
    self.containerView.height = CGRectGetMaxY(content.frame)+ self.kContentMarginD;
    //添加内容到灰色图片中
    [self.containerView addSubview:content];
}

- (void)setContentVc:(UIViewController *)contentVc
{
    _contentVc = contentVc;
    
    self.content = contentVc.view;
}

//显示
- (void) showFrom:(UIView *)view
{
    //这样获得的窗口，是目前显示在屏幕最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    //2.添加自己到窗口上
    [window addSubview:self];
    
    //3.设置尺寸
    self.frame = window.bounds;
    
    //4.调整灰色图片的位置
    //默认情况下frame是以父控件左上角作为坐标原点，可以通过转换坐标系原点，改变frame的参照点
    //将view.frame的坐标参考点从view.superview变为window
    CGRect newFrame = [view.superview convertRect:view.frame toView:window];
    //等价于下面的
    //CGRect newFrame = [view convertRect:view.bounds toView:window];
    
    switch (self.position) {
        case MenuShowPositionL:
        {
            self.containerView.y = CGRectGetMaxY(newFrame);
            self.containerView.x = CGRectGetMinX(newFrame);
        }
            break;
        case MenuShowPositionC:
        {
            self.containerView.y = CGRectGetMaxY(newFrame);
            self.containerView.centerX = CGRectGetMidX(newFrame);
        }
            break;
        case MenuShowPositionR:
        {
            self.containerView.y = CGRectGetMaxY(newFrame);
            self.containerView.x = CGRectGetMaxX(newFrame) - self.containerView.width;
        }
            break;
            
        default:
            break;
    }
    
    
    //通知代理设置箭头向上
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidshow:)]) {
        [self.delegate dropdownMenuDidshow:self];
    }
}
//销毁
- (void) dismiss
{
    //通知代理设置箭头上下
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidmiss:)]) {
        [self.delegate dropdownMenuDidmiss:self];
    }
    
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

@end
