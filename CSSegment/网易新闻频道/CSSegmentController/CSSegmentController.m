//
//  CSSegmentController.m
//  网易新闻频道
//
//  Created by user on 2018/4/16.
//  Copyright © 2018年 LCS. All rights reserved.
//

#import "CSSegmentController.h"
#import "CSTableViewController.h"
#import "CSSegmentLabel.h"
#import "UIView+Extensions.h"

@interface CSSegmentController ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollTitle;
@property (strong, nonatomic) UIScrollView *scrollContent;

@property(nonatomic, strong) UIView *topLineView;

@property (nonatomic, strong) NSArray *controllerArr;
@property (nonatomic, strong) NSArray *titleArr;

/**
 是否需要下划线
 */
@property (nonatomic, assign) BOOL isShowUnderLine;
/**
 字体是否渐变
 */
@property (nonatomic, assign) BOOL isShowTitleGradient;
/**
 字体放大
 */
@property (nonatomic, assign) BOOL isShowTitleScale;
/**
 是否显示遮盖
 */
@property (nonatomic, assign) BOOL isShowTitleCover;

/**
 字体缩放比例
 */
@property (nonatomic, assign) CGFloat titleScale;
/**
 标题高度
 */
@property (nonatomic, assign) CGFloat titleHeight;

/**
 标题宽度
 */
@property (nonatomic, assign) CGFloat titleWidth;
/**
 标题字体
 */
@property (nonatomic, strong) UIFont *titleFont;
/**
 标题颜色
 */
@property (nonatomic, strong) UIColor *norColor;
@property (nonatomic, strong) UIColor *selColor;
/**
 开始颜色,取值范围0~1
 */
@property (nonatomic, assign) CGFloat startR;

@property (nonatomic, assign) CGFloat startG;

@property (nonatomic, assign) CGFloat startB;

/**
 完成颜色,取值范围0~1
 */
@property (nonatomic, assign) CGFloat endR;

@property (nonatomic, assign) CGFloat endG;

@property (nonatomic, assign) CGFloat endB;
/**
 标题滚动视图背景颜色
 */
@property (nonatomic, strong) UIColor *titleScrollViewColor;
/**
 颜色渐变样式
 */
@property (nonatomic, assign) CSTitleColorGradientStyle titleColorGradientStyle;

/**
 下标颜色
 */
@property (nonatomic, strong) UIColor *underLineColor;

/**
 下标高度
 */
@property (nonatomic, assign) CGFloat underLineH;
/**
 是否延迟滚动下标
 */
@property (nonatomic, assign) BOOL isDelayScroll;
/**
 *  下标宽度是否等于标题宽度
 */
@property (nonatomic, assign) BOOL isUnderLineEqualTitleWidth;
/** 记录上一次内容滚动视图偏移量 */
@property (nonatomic, assign) CGFloat lastOffsetX;



@end

@implementation CSSegmentController

- (instancetype)initWithControllerArr:(NSArray *)controllerArr TitleArr:(NSArray *)titleArr{
    if (self = [super init]) {
        _controllerArr = controllerArr;
        _titleArr = titleArr;
        
        [self otherInit];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //取消自动调整contentInset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //创建顶部
    [self setUpTitle];
    //创建底部
    [self setUpContent];

}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    _scrollTitle.frame = CGRectMake(0, 0, self.view.width, _titleHeight);
    _scrollContent.frame = CGRectMake(0, _scrollTitle.bounds.size.height, self.view.width, self.view.height - _scrollTitle.bounds.size.height);
}

#pragma mark Event

- (void)titleOnClick:(UIGestureRecognizer *)recognizer{
    
    
    CGPoint offsetX = CGPointMake(recognizer.view.tag * self.view.width, 0);
    // 记录上一次的偏移量
    _lastOffsetX = offsetX.x;
    
    [self.scrollContent setContentOffset:offsetX animated:NO];
    
    [self scrollViewDidEndScrollingAnimation:self.scrollContent];
}

#pragma mark UIScrollViewDelegate
//scrollview手动拖拽结束后调用，
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:self.scrollContent];
}
//通过代码的方式滚动scrollview结束后调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    UIViewController *vc = self.childViewControllers[index];
    
    CSSegmentLabel *label = self.scrollTitle.subviews[index];
    
    // 选中标题
    [self selectLabel:label];
    
    //如果控制器的view加载过了则返回
    if ([vc isViewLoaded]) {
        
        // 发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:CSTitleClickOrScrollDidFinshNoti object:vc];
        return;
    }
    
    vc.view.frame = CGRectMake(index * scrollView.bounds.size.width, 0, scrollView.bounds.size.width, scrollView.bounds.size.height);
    
    [scrollView addSubview:vc.view];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat scale = offsetX / self.view.width;
    
    //需要操作的左边label
    NSInteger leftIndex = scale;
    //需要操作的右边label
    NSInteger rightIndex = leftIndex + 1;
    
    if (scale < 0 || rightIndex > scrollView.contentSize.width / self.view.width - 1) {
        return;
    }
    
    //取出对应的label
    CSSegmentLabel *leftLabel = self.scrollTitle.subviews[leftIndex];
    CSSegmentLabel *rightLabel = self.scrollTitle.subviews[rightIndex];
    
    
    //设置label的比例
    CGFloat rightScale = scale - leftIndex;
    CGFloat leftScale = 1 - rightScale;
    
    // 字体缩放
    [self setUpTitleScaleWithLeftScale:leftScale rightScale:rightScale leftLabel:leftLabel rightLabel:rightLabel];

    
    // 设置下标偏移
    [self setUpUnderLineWithOffset:offsetX leftLabel:leftLabel rightLabel:rightLabel];
//
//    // 设置遮盖偏移
//    [self setUpCoverOffset:offsetX rightLabel:rightLabel leftLabel:leftLabel];
//
    // 设置标题渐变
    [self setUpTitleColorGradientWithLeftScale:leftScale rightScale:rightScale leftLabel:leftLabel rightLabel:rightLabel];
//
    // 记录上一次的偏移量
    _lastOffsetX = scrollView.contentOffset.x;
    
    
    
    
}
#pragma mark - Public
- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    
    if (self.scrollTitle.subviews.count > 1) {
        
        CSSegmentLabel *label = self.scrollTitle.subviews[selectIndex];
        
        [self titleOnClick:[label.gestureRecognizers firstObject]];
    }
}

- (void)setUpTitleScale:(void(^)(CGFloat *titleScale))titleScaleBlock{
    
    _isShowTitleScale = YES;
    
    if (titleScaleBlock) {
        titleScaleBlock(&_titleScale);
    }
}
- (void)setUpTitleColorGradient{
    
    _isShowTitleGradient = YES;
}
- (void)setUpUnderLineEffect:(void(^)(BOOL *isDelayScroll,CGFloat *underLineH,UIColor * __strong*underLineColor,BOOL *isUnderLineEqualTitleWidth))underLineBlock
{
    _isShowUnderLine = YES;
    
    if (underLineBlock) {
        underLineBlock(&_isDelayScroll,&_underLineH,&_underLineColor,&_isUnderLineEqualTitleWidth);
    }
    
}


#pragma mark - Private

- (void)otherInit{
    
    self.titleWidth = CSTitleViewW;
    self.titleHeight = CSTitleScrollViewH;
    self.titleScrollViewColor = [UIColor whiteColor];
    self.titleFont = [UIFont systemFontOfSize:14];
    self.norColor = [UIColor redColor];
    self.selColor = [UIColor yellowColor];
    self.underLineColor = [UIColor redColor];
    self.underLineH = 2;
}

- (void)setUpTitle{
    
    _scrollTitle = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, _titleHeight)];
    _scrollTitle.scrollEnabled = YES;
    _scrollTitle.showsHorizontalScrollIndicator = NO;
    _scrollTitle.backgroundColor = _titleScrollViewColor;
    [self.view addSubview:_scrollTitle];
    
    NSInteger count = _titleArr.count;
    CGFloat labelW = _titleWidth;
    CGFloat labelH = _scrollTitle.bounds.size.height;
    CGFloat labelY = 0;
    
    for (int i = 0; i < count; i++) {
        CGFloat labelX = i * labelW;
        CSSegmentLabel *label = [[CSSegmentLabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
        label.text = self.titleArr[i];
        label.font = _titleFont;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleOnClick:)];
        [label addGestureRecognizer:tap];
        label.tag = i;
        [_scrollTitle addSubview:label];
        
    }
    _scrollTitle.contentSize = CGSizeMake(count * _titleWidth, 0);
    
    // 创建标题底部滚动条
    _topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, _scrollTitle.bounds.size.height - _underLineH, labelW, _underLineH)];
    _topLineView.backgroundColor = _underLineColor;
    [_scrollTitle addSubview:_topLineView];
    
}


- (void)setUpContent{
    
    _scrollContent = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _scrollTitle.bounds.size.height, self.view.width, self.view.height - _scrollTitle.bounds.size.height)];
    _scrollContent.contentSize = CGSizeMake(self.controllerArr.count * _scrollContent.width, 0);
    _scrollContent.bounces = NO;
    _scrollContent.pagingEnabled = YES;
    _scrollContent.delegate = self;
    _scrollContent.canCancelContentTouches = NO;
    _scrollContent.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollContent];
    
    for (int i = 0; i < _controllerArr.count; i ++) {
        UIViewController *vc = _controllerArr[i];
        [self addChildViewController:vc];
        
    }
    
    
}


- (void)selectLabel:(CSSegmentLabel *)label
{
    // 恢复其他label样式
    for (CSSegmentLabel *labelView in self.scrollTitle.subviews) {
        
        if ([labelView isKindOfClass:[CSSegmentLabel class]]) {
            if (label == labelView) continue;
            
            if (_isShowTitleScale) {
                labelView.transform = CGAffineTransformIdentity;
            }
            
            labelView.textColor = self.norColor;
            
            //            if (_isShowTitleGradient && _titleColorGradientStyle == YZTitleColorGradientStyleFill) {
            //
            //                labelView.fillColor = self.norColor;
            //
            //                labelView.progress = 1;
            //            }
        }
    }
    
    // 设置选中label样式
    // 标题缩放
    if (_isShowTitleScale) {
        
        CGFloat scaleTransform = _titleScale?_titleScale:CSTitleTransformScale;
        
        label.transform = CGAffineTransformMakeScale(scaleTransform, scaleTransform);
    }
    
    // 修改标题选中颜色
    label.textColor = self.selColor;
    
    // 设置标题居中
    [self setUpLabelTitleCenter:label];
    
    // 设置下标的位置
    [self setUpUnderLine:label];
    //
    //    // 设置cover
    //    if (_isShowTitleCover) {
    //        [self setUpCoverView:label];
    //    }
    
}

- (void)setLineOffset:(NSInteger)index{
    CSSegmentLabel *label = self.scrollTitle.subviews[index];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.topLineView.centerX = label.centerX;
    }];
}

- (void)setUpLabelTitleCenter:(CSSegmentLabel *)label{
    
    // 不可滚动
    if (self.scrollTitle.contentSize.width <= self.scrollTitle.width) {
        return;
    }
    
    CGPoint offset = CGPointMake(label.center.x - self.view.width/2, 0);
    //边界处理
    offset.x = offset.x < 0 ? 0 : offset.x;
    offset.x = offset.x > self.scrollTitle.contentSize.width - self.view.width ? self.scrollTitle.contentSize.width - self.view.width : offset.x;
    [self.scrollTitle setContentOffset:offset animated:YES];
    
}

// 设置下标的位置
- (void)setUpUnderLine:(UILabel *)label
{
    if (!_isShowUnderLine) {
        return;
    }
    // 获取文字尺寸
    CGRect titleBounds = [label.text boundingRectWithSize:CGSizeMake(self.titleWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil];
    
    // 点击时候需要动画
    [UIView animateWithDuration:0.25 animations:^{
        if (_isUnderLineEqualTitleWidth) {
            self.topLineView.width = titleBounds.size.width;
        } else {
            self.topLineView.width = label.width;
        }
        self.topLineView.centerX = label.centerX;
    }];
    
}
#pragma mark - 标题效果
- (void)setUpTitleEffect:(void(^)(UIColor * __strong*titleScrollViewColor,UIColor * __strong*norColor,UIColor * __strong*selColor,UIFont * __strong*titleFont,CGFloat *titleHeight,CGFloat *titleWidth))titleEffectBlock{
    UIColor *norColor;
    UIColor *selColor;
    if (titleEffectBlock) {
        titleEffectBlock(&_titleScrollViewColor,&norColor,&selColor,&_titleFont,&_titleHeight,&_titleWidth);
        if (norColor) {
            self.norColor = norColor;
        }
        if (selColor) {
            self.selColor = selColor;
        }
    }
    
}
// 设置标题缩放
- (void)setUpTitleScaleWithLeftScale:(CGFloat)leftScale
                          rightScale:(CGFloat)rightScale
                           leftLabel:(CSSegmentLabel *)leftLabel
                          rightLabel:(CSSegmentLabel *)rightLabel{
    if (_isShowTitleScale == NO) return;
    
    CGFloat scaleTransform = _titleScale?_titleScale:CSTitleTransformScale;
    
    scaleTransform -= 1;
    
    // 缩放按钮
    leftLabel.transform = CGAffineTransformMakeScale(leftScale * scaleTransform + 1, leftScale * scaleTransform + 1);
    
    // 1 ~ 1.3
    rightLabel.transform = CGAffineTransformMakeScale(rightScale * scaleTransform + 1, rightScale * scaleTransform + 1);
}

// 设置标题颜色渐变
- (void)setUpTitleColorGradientWithLeftScale:(CGFloat)leftScale
                                  rightScale:(CGFloat)rightScale
                                   leftLabel:(CSSegmentLabel *)leftLabel
                                  rightLabel:(CSSegmentLabel *)rightLabel
{
    if (_isShowTitleGradient == NO) return;
    
    // RGB渐变
    if (_titleColorGradientStyle == CSTitleColorGradientStyleRGB) {
        
        CGFloat r = _endR - _startR;
        CGFloat g = _endG - _startG;
        CGFloat b = _endB - _startB;
        
        // rightColor
        // 1 0 0
        UIColor *rightColor = [UIColor colorWithRed:_startR + r * rightScale green:_startG + g * rightScale blue:_startB + b * rightScale alpha:1];
        
        // 0.3 0 0
        // 1 -> 0.3
        // leftColor
        UIColor *leftColor = [UIColor colorWithRed:_startR +  r * leftScale  green:_startG +  g * leftScale  blue:_startB +  b * leftScale alpha:1];
        
        // 右边颜色
        rightLabel.textColor = rightColor;
        
        // 左边颜色
        leftLabel.textColor = leftColor;
        return;
    }
    
    // 填充渐变
    if (_titleColorGradientStyle == CSTitleColorGradientStyleFill) {
        
        // 获取移动距离
//        CGFloat offsetDelta = offsetX - _lastOffsetX;
//
//        if (offsetDelta > 0) { // 往右边
//            rightLabel.textColor = self.norColor;
//            rightLabel.fillColor = self.selColor;
//            rightLabel.progress = rightSacle;
//
//            leftLabel.textColor = self.selColor;
//            leftLabel.fillColor = self.norColor;
//            leftLabel.progress = rightSacle;
//
//        } else if(offsetDelta < 0){ // 往左边
//
//            rightLabel.textColor = self.norColor;
//            rightLabel.fillColor = self.selColor;
//            rightLabel.progress = rightSacle;
//
//            leftLabel.textColor = self.selColor;
//            leftLabel.fillColor = self.norColor;
//            leftLabel.progress = rightSacle;
//
//        }
    }
}
- (void)setUpUnderLineWithOffset:(CGFloat)offsetX
                           leftLabel:(CSSegmentLabel *)leftLabel
                          rightLabel:(CSSegmentLabel *)rightLabel{
    
    if (_isDelayScroll) {
        return;
    }
    
    // 获取两个标题中心点距离
    CGFloat centerDelta = rightLabel.centerX - leftLabel.centerX;
    
    // 标题宽度差值
    CGFloat widthDelta = [self widthDeltaWithRightLabel:rightLabel leftLabel:leftLabel];
    
    // 获取移动距离
    CGFloat offsetDelta = offsetX - _lastOffsetX;
    
    // 计算当前下划线偏移量
    CGFloat underLineTransformX = offsetDelta * centerDelta / self.view.width;
    
    // 宽度递增偏移量
    CGFloat underLineWidth = offsetDelta * widthDelta / self.view.width;
    
    self.topLineView.width += underLineWidth;
    self.topLineView.centerX += underLineTransformX;
}
// 获取两个标题按钮宽度差值
- (CGFloat)widthDeltaWithRightLabel:(UILabel *)rightLabel leftLabel:(UILabel *)leftLabel
{
    if (_isUnderLineEqualTitleWidth) {
        CGRect titleBoundsR = [rightLabel.text boundingRectWithSize:CGSizeMake(self.titleWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil];
        
        CGRect titleBoundsL = [leftLabel.text boundingRectWithSize:CGSizeMake(self.titleWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil];
        
        return titleBoundsR.size.width - titleBoundsL.size.width;
    }else{
        return 0;
    }
    
}

#pragma mark - 颜色操作

- (void)setNorColor:(UIColor *)norColor
{
    _norColor = norColor;
    [self setupStartColor:norColor];
    
}

- (void)setSelColor:(UIColor *)selColor
{
    _selColor = selColor;
    [self setupEndColor:selColor];
}

- (void)setupStartColor:(UIColor *)color
{
    CGFloat components[3];
    
    [self getRGBComponents:components forColor:color];
    
    _startR = components[0];
    _startG = components[1];
    _startB = components[2];
}

- (void)setupEndColor:(UIColor *)color
{
    CGFloat components[3];
    
    [self getRGBComponents:components forColor:color];
    
    _endR = components[0];
    _endG = components[1];
    _endB = components[2];
}



/**
 *  指定颜色，获取颜色的RGB值
 *
 *  @param components RGB数组
 *  @param color      颜色
 */
- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 1);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}

@end
