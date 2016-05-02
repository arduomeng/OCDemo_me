//
//  ViewController.m
//  CSLeftSlideDemo
//
//  Created by LCS on 16/2/11.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "CSLeftSlideControllerTwo.h"
#import "LeftViewController.h"
#import "OtherViewController.h"
#import "UIView+Extensions.h"
#import "Constants.h"
@interface CSLeftSlideControllerTwo () <LeftViewControllerDelegate>

@property (nonatomic, strong) UIViewController *mainVC;
@property (nonatomic, strong) LeftViewController *leftVC;

@property (nonatomic, assign) CGFloat PanGestureNowX;
@end

@implementation CSLeftSlideControllerTwo

- (id)initWithLeftViewController:(UIViewController *)leftVC MainViewController:(UIViewController *)mainVC{
    self = [super init];
    if (self) {
        [self setupMainVC:mainVC];
        [self setupLeftVC:leftVC];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIImageView *bg = [[UIImageView alloc] init];
//    bg.frame = self.view.bounds;
//    bg.image = [UIImage imageNamed:@"sidebar_bg"];
//    [self.view insertSubview:bg atIndex:0];
    
    
    UIPanGestureRecognizer *tap = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
    [self.view addGestureRecognizer:tap];
    
    //接收侧滑通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationLeftSlide) name:kNotificationLeftSlide object:nil];
}

- (void)panGestureHandler:(UIPanGestureRecognizer *)PanGestureRecognizer{
    UIView *mainView = _mainVC.view;
    UIView *leftView = _leftVC.view;
    //判断最终位置
    if (PanGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        if (leftView.x > -kLeftViewW/2) {
            [UIView animateWithDuration:kDuration animations:^{
                
                leftView.x = 0;
            }];
            
            //添加遮盖
            UIButton *cover = [mainView viewWithTag:3344];
            if (!cover) {
                cover = [[UIButton alloc] initWithFrame:mainView.bounds];
                cover.tag = kcoverTag;
                [cover addTarget:self action:@selector(onClickCover:) forControlEvents:UIControlEventTouchUpInside];
                [mainView addSubview:cover];
            }
            
        }else{
            [UIView animateWithDuration:kDuration animations:^{
                
                leftView.x = -kLeftViewW;
            }];
            UIButton *cover = [mainView viewWithTag:kcoverTag];
            if (cover) {
                [self onClickCover:cover];
            }
            
        }
    }
    //响应手势侧滑
    _PanGestureNowX = [PanGestureRecognizer translationInView:self.view].x;
    [PanGestureRecognizer setTranslation:CGPointZero inView:self.view];
    
    [self animateWithDuration:kDuration Transform:_PanGestureNowX leftView:leftView];
    
}

- (void)animateWithDuration:(CGFloat)duration Transform:(CGFloat)offsetX leftView:(UIView *)leftView{
    
    leftView.x += offsetX;
    
    if (leftView.x > 0) {
        leftView.x = 0;
    }else if (leftView.x < -kLeftViewW){
        leftView.x = -kLeftViewW;
    }
}

- (void)setupMainVC:(UIViewController *)mainVC
{
    _mainVC = mainVC;
    
    [self addChildViewController:mainVC];
    [self.view addSubview:mainVC.view];
}

- (void)setupLeftVC:(UIViewController *)leftVC
{
    _leftVC = leftVC;
    [self addChildViewController:leftVC];
    [self.view addSubview:leftVC.view];
    _leftVC.view.y = 20;
    _leftVC.view.x = -kLeftViewW;
    _leftVC.view.height = kLeftViewH;
    _leftVC.view.width = kLeftViewW;
    //设置左侧界面的代理
    _leftVC.delegate = self;
}

- (void)onClickCover:(UIButton *)cover
{
    [UIView animateWithDuration:kDuration animations:^{
        _leftVC.view.x = -kLeftViewW;
    } completion:^(BOOL finished) {
        [cover removeFromSuperview];
    }];
}

- (void)notificationLeftSlide{
    
    UIView *mainView = _mainVC.view;
    UIView *leftView = _leftVC.view;
    [UIView animateWithDuration:kDuration animations:^{
        leftView.x = 0;
    }];
    
    //添加遮盖
    UIButton *cover = [mainView viewWithTag:3344];
    if (!cover) {
        cover = [[UIButton alloc] initWithFrame:mainView.bounds];
        cover.tag = kcoverTag;
        [cover addTarget:self action:@selector(onClickCover:) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:cover];
    }
}
//左侧界面的代理方法
#pragma mark LeftViewControllerDelegate

- (void)LeftViewControllerdidSelectRow:(LeftViewControllerRowType)LeftViewControllerRowType{
    UIButton *cover = [_mainVC.view viewWithTag:kcoverTag];
    [self onClickCover:cover];
    
    if (LeftViewControllerRowType == LeftViewControllerRowTypeOne) {
        NSLog(@"LeftViewControllerRowTypeOne");
    }else if (LeftViewControllerRowType == LeftViewControllerRowTypeTwo){
        NSLog(@"LeftViewControllerRowTypeTwo");
    }else if (LeftViewControllerRowType == LeftViewControllerRowTypeThree){
        NSLog(@"LeftViewControllerRowTypeThree");
    }
    
    OtherViewController *vc = [[OtherViewController alloc] init];
    UINavigationController *nav = (UINavigationController *)_mainVC;
    [nav popToRootViewControllerAnimated:NO];
    [nav pushViewController:vc animated:NO];
}

@end
