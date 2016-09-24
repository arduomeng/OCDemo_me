//
//  CSTabbarController.m
//  CSTabbarController
//
//  Created by LCS on 16/8/2.
//  Copyright © 2016年 LCS. All rights reserved.
//

//
//  ViewController.m
//  CSTabbarController
//
//  Created by LCS on 16/8/1.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "CSTabbarController.h"
#import "Common.h"
#import "CSLabel.h"
@interface CSTabbarController () <UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *topView;
@property(nonatomic, strong) UIScrollView *bottomView;

@property(nonatomic, strong) UIView *topLineView;

@property (nonatomic, strong) NSArray *controllerArr;
@property (nonatomic, strong) NSArray *titleArr;

@end

@implementation CSTabbarController

- (instancetype)initWithControllerArr:(NSArray *)controllerArr TitleArr:(NSArray *)titleArr{
    if (self = [super init]) {
        _controllerArr = controllerArr;
        _titleArr = titleArr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //取消自动调整contentInset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //创建底部
    [self setUpContent];
    
    //创建顶部
    [self setUpTitle];
    
    //默认点击第一个
    [self scrollViewDidEndScrollingAnimation:self.bottomView];
}


- (void)setUpContent{
    
    _bottomView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, self.view.bounds.size.height - 30)];
    _bottomView.pagingEnabled = YES;
    _bottomView.delegate = self;
    [self.view addSubview:_bottomView];
    
    for (UIViewController *VC in _controllerArr) {
        [self addChildViewController:VC];
    }
    
}

- (void)setUpTitle{
    
    _topView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    [self.view addSubview:_topView];
    
    NSInteger count = _titleArr.count;
    CGFloat labelW = kScreenWidth / count;
    CGFloat labelH = _topView.bounds.size.height;
    CGFloat labelY = 0;
    
    for (int i = 0; i < count; i++) {
        CGFloat labelX = i * labelW;
        CSLabel *label = [[CSLabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
        label.text = self.childViewControllers[i].title;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleOnClick:)];
        [label addGestureRecognizer:tap];
        label.tag = i;
        [_topView addSubview:label];
        
        //设置第一个label变化
        if (i == 0) {
            label.scale = 1;
        }
    }
    
    // 创建标题底部滚动条
    _topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.bounds.size.height - 2, labelW, 2)];
    _topLineView.backgroundColor = [UIColor redColor];
    [_topView addSubview:_topLineView];
    
    self.topView.scrollEnabled = NO;
    self.bottomView.contentSize = CGSizeMake(count * [UIScreen mainScreen].bounds.size.width, 0);
}

- (void)titleOnClick:(UIGestureRecognizer *)recognizer{
    CGPoint offsetX = CGPointMake(recognizer.view.tag * [UIScreen mainScreen].bounds.size.width, 0);
    [self.bottomView setContentOffset:offsetX animated:YES];
}

//scrollview手动拖拽结束后调用，
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:self.bottomView];
}
//通过代码的方式滚动scrollview结束后调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    NSInteger vcIndex = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    UIViewController *vc = self.childViewControllers[vcIndex];
    
    //取消其他label的变化
    for (UIView *label in self.topView.subviews) {
        if ([label isKindOfClass:[CSLabel class]]) {
            CSLabel *csLabel = (CSLabel *)label;
            if (csLabel != self.topView.subviews[vcIndex]) {
                csLabel.scale = 0;
            }
            continue;
        }
        
    }
    
    //设置title居中显示
    //[self setTitleOffset:vcIndex];
    
    //如果控制器的view加载过了则返回
    if ([vc isViewLoaded]) {
        return;
    }
    
    vc.view.frame = CGRectMake(vcIndex * scrollView.bounds.size.width, 0, scrollView.bounds.size.width, scrollView.bounds.size.height);
    
    [scrollView addSubview:vc.view];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat scale = scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    
    //需要操作的左边label
    NSInteger leftIndex = scale;
    //需要操作的右边label
    NSInteger rightIndex = leftIndex + 1;
    
    if (scale < 0 || rightIndex > scrollView.contentSize.width / [UIScreen mainScreen].bounds.size.width - 1) {
        return;
    }
    
    //取出对应的label
    CSLabel *leftLabel = self.topView.subviews[leftIndex];
    CSLabel *rightLabel = self.topView.subviews[rightIndex];
    
    //设置label的比例
    CGFloat rightScale = scale - leftIndex;
    CGFloat leftScale = 1 - rightScale;
    
    leftLabel.scale = leftScale;
    rightLabel.scale = rightScale;
    
    //设置topLineView
    CGFloat offsetScale = scrollView.contentOffset.x / scrollView.bounds.size.width;
    CGRect frame = _topLineView.frame;
    frame.origin.x = offsetScale * (_topView.bounds.size.width / _titleArr.count);
    _topLineView.frame = frame;
}
/*
 
 - (void)setTitleOffset:(NSInteger)index{
 CSLabel *label = self.scrollTitle.subviews[index];
 CGPoint offset = CGPointMake(label.center.x - [UIScreen mainScreen].bounds.size.width/2, 0);
 //边界处理
 offset.x = offset.x < 0 ? 0 : offset.x;
 offset.x = offset.x > self.scrollTitle.contentSize.width - [UIScreen mainScreen].bounds.size.width ? self.scrollTitle.contentSize.width - [UIScreen mainScreen].bounds.size.width : offset.x;
 [self.scrollTitle setContentOffset:offset animated:YES];
 }
 */


@end
