//
//  UICollectionViewLineLayout.m
//  UICollectionView实例
//
//  Created by LCS on 16/5/1.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "UICollectionViewLineLayout.h"

@implementation UICollectionViewLineLayout

/*
    继承自UICollectionViewFlowLayout和UICollectionViewLayout的区别
    UICollectionViewFlowLayout：
        layoutAttributesForElementsInRect方法中调用[super layoutAttributesForElementsInRect:rect]能得到rect范围内的UICollectionViewLayoutAttributes属性数组
        实现shouldInvalidateLayoutForBoundsChange方法。当collectionView显示的区域发生变化时调用1.prepareLayout  2.layoutAttributesForElementsInRect刷新界面
        当collectionView需要切换布局样式为自己的时候，不需要实现layoutAttributesForItemAtIndexPath方法
    UICollectionViewLayout：
        layoutAttributesForElementsInRect方法中调用[super layoutAttributesForElementsInRect:rect]得不到item的属性数组，一切属性需要自己设置
        不需要实现shouldInvalidateLayoutForBoundsChange方法。且prepareLayout只调用一次，layoutAttributesForElementsInRect调用多次
        当collectionView需要切换布局样式为自己的时候，需要实现layoutAttributesForItemAtIndexPath方法.返回indexPath位置对应的cell的局部属性UICollectionViewLayoutAttributes
        需要实现collectionViewContentSize方法，实现滚动
 */

- (instancetype)init{
    
    if (self = [super init]) {
        
        
    }
    
    return self;
}
/**
 *  进行一些collectionView和layout的初始化操作
 */
- (void)prepareLayout{
    
    NSLog(@"prepareLayout");
    
    [super prepareLayout];
    
    self.collectionView.showsHorizontalScrollIndicator = false;
    self.collectionView.showsVerticalScrollIndicator = false;
    
    self.itemSize = CGSizeMake(200, 200);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 设置开始的偏移值 (由于transform的改变都是假象，所以内边距根据item原始的frame计算)
    CGFloat inset = ([UIScreen mainScreen].bounds.size.width - self.itemSize.width) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);

}

// 当collectionView显示的区域发生变化时是否调用1.prepareLayout  2.layoutAttributesForElementsInRect刷新界面

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

// 该方法的返回值是一个数组,(存放了rect范围内所有元素的布局属性)
// 一个item 对应一个UICollectionViewLayoutAttributes属性,里面包换了item的frame，transform等等信息
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    NSLog(@"layoutAttributesForElementsInRect");
    
    NSArray *attributesArr = [super layoutAttributesForElementsInRect:rect];
    
    // 相册中心点(collectionView偏移值 ＋ 相册宽度的一半)
    CGFloat centerX = self.collectionView.contentOffset.x + [UIScreen mainScreen].bounds.size.width * 0.5;
    
    for (UICollectionViewLayoutAttributes *attr in attributesArr) {
        // 获取每一个item中心点，计算缩放比例
        CGFloat scale = 1 - fabs(attr.center.x - centerX) / ([UIScreen mainScreen].bounds.size.width * 0.5);
        attr.transform = CGAffineTransformMakeScale(scale, scale);
        
    }
    return attributesArr;
}

// 该方法的返回值决定了collectionView停止时的偏移量 注意：方法的调用是在手松开的时候调用
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    // proposedContentOffset 原本collectionView停止时候的偏移量
    // 获取最终停止时候的rect，调用layoutAttributesForElementsInRect获取该范围内的item布局属性
    CGFloat X = proposedContentOffset.x;
    CGFloat Y = 0;
    CGFloat W = self.collectionView.bounds.size.width;
    CGFloat H = self.collectionView.bounds.size.height;
    CGRect rect = CGRectMake(X, Y, W, H);
    
    
    // 相册中心点(collectionView最终偏移值 ＋ 相册宽度的一半)
    CGFloat centerX = proposedContentOffset.x + [UIScreen mainScreen].bounds.size.width * 0.5;
    
    NSArray *attributesArr = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat minOffset = MAXFLOAT;
    CGFloat isPositive = 1;
    for (UICollectionViewLayoutAttributes *attr in attributesArr) {
        // 获取每一个item中心点，判断哪个item离中心点最近
        if (fabs(attr.center.x - centerX) < minOffset) {
            
            isPositive = (attr.center.x - centerX) > 0 ? 1 : -1;
            minOffset = fabs(attr.center.x - centerX);
            
        }
    }
    
    proposedContentOffset.x += minOffset * isPositive;
    
    return proposedContentOffset;
}

@end
