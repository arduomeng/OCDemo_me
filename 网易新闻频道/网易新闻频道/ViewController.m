//
//  ViewController.m
//  网易新闻频道
//
//  Created by LCS on 16/4/6.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "ViewController.h"
#import "CSTableViewController.h"
#import "CSLabel.h"

@interface ViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollContent;

//@property (nonatomic, assign) NSInteger nowPage;
//@property (nonatomic, assign) NSInteger nextPage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //取消自动调整contentInset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //创建底部
    [self setUpContent];
    
    //创建顶部
    [self setUpTitle];
    
    //默认点击第一个
    [self scrollViewDidEndScrollingAnimation:self.scrollContent];
    

}

- (void)setUpContent{
    UIViewController *vc = [[CSTableViewController alloc] init];
    vc.title = @"头条";
    [self addChildViewController:vc];
    UIViewController *vc2 = [[CSTableViewController alloc] init];
    vc2.title = @"财经";
    [self addChildViewController:vc2];
    UIViewController *vc3 = [[CSTableViewController alloc] init];
    vc3.title = @"娱乐";
    [self addChildViewController:vc3];
    UIViewController *vc4 = [[CSTableViewController alloc] init];
    vc4.title = @"要闻";
    [self addChildViewController:vc4];
    UIViewController *vc5 = [[CSTableViewController alloc] init];
    vc5.title = @"科技";
    [self addChildViewController:vc5];
    UIViewController *vc6 = [[CSTableViewController alloc] init];
    vc6.title = @"段子";
    [self addChildViewController:vc6];
    UIViewController *vc7 = [[CSTableViewController alloc] init];
    vc7.title = @"故事";
    [self addChildViewController:vc7];
    UIViewController *vc8 = [[CSTableViewController alloc] init];
    vc8.title = @"股市";
    [self addChildViewController:vc8];
}

- (void)setUpTitle{
    
    CGFloat labelW = 100;
    CGFloat labelH = self.scrollTitle.bounds.size.height;
    CGFloat labelY = 0;
    
    for (int i = 0; i < 8; i++) {
        CGFloat labelX = i * labelW;
        CSLabel *label = [[CSLabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
        label.text = self.childViewControllers[i].title;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleOnClick:)];
        [label addGestureRecognizer:tap];
        label.tag = i;
        [self.scrollTitle addSubview:label];
        
        //设置第一个label变化
        if (i == 0) {
            label.scale = 1;
        }
    }
    
    self.scrollTitle.contentSize = CGSizeMake(8 * labelW, 0);
    self.scrollContent.contentSize = CGSizeMake(8 * [UIScreen mainScreen].bounds.size.width, 0);
}

- (void)titleOnClick:(UIGestureRecognizer *)recognizer{
    CGPoint offsetX = CGPointMake(recognizer.view.tag * [UIScreen mainScreen].bounds.size.width, 0);
    [self.scrollContent setContentOffset:offsetX animated:YES];
}

//scrollview手动拖拽结束后调用，
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:self.scrollContent];
}
//通过代码的方式滚动scrollview结束后调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    NSInteger vcIndex = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    UIViewController *vc = self.childViewControllers[vcIndex];
    
    //取消其他label的变化
    for (CSLabel *label in self.scrollTitle.subviews) {
        if (label != self.scrollTitle.subviews[vcIndex]) {
            label.scale = 0;
        }
    }
    
    //设置title居中显示
    [self setTitleOffset:vcIndex];
    
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

    NSLog(@"%ld, %ld", leftIndex, rightIndex);
    //取出对应的label
    CSLabel *leftLabel = self.scrollTitle.subviews[leftIndex];
    
    CSLabel *rightLabel = self.scrollTitle.subviews[rightIndex];
    
    //设置label的比例
    CGFloat rightScale = scale - leftIndex;
    CGFloat leftScale = 1 - rightScale;
    
    leftLabel.scale = leftScale;
    rightLabel.scale = rightScale;
    
    
}


- (void)setTitleOffset:(NSInteger)index{
    CSLabel *label = self.scrollTitle.subviews[index];
    CGPoint offset = CGPointMake(label.center.x - [UIScreen mainScreen].bounds.size.width/2, 0);
    //边界处理
    offset.x = offset.x < 0 ? 0 : offset.x;
    offset.x = offset.x > self.scrollTitle.contentSize.width - [UIScreen mainScreen].bounds.size.width ? self.scrollTitle.contentSize.width - [UIScreen mainScreen].bounds.size.width : offset.x;
    [self.scrollTitle setContentOffset:offset animated:YES];
}

@end
