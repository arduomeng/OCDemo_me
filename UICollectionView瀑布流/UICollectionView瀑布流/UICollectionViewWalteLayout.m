//
//  UICollectionViewWalteLayout.m
//  UICollectionView瀑布流
//
//  Created by LCS on 16/5/1.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "UICollectionViewWalteLayout.h"

// 如果设置成框架，则这些常亮的设置应该设计成代理方法，由外界决定
static const CGFloat colMargin = 15;
static const CGFloat rowMargin = 20;
static const UIEdgeInsets edgeInset = {10, 10, 10, 10};
static const CGFloat colNumbers = 3;

@interface UICollectionViewWalteLayout ()

@property (nonatomic, strong) NSMutableArray *attributesArr;

// 存放每一列的最大Y值
@property (nonatomic, strong) NSMutableArray *columnMaxY;

@end

@implementation UICollectionViewWalteLayout

- (NSMutableArray *)attributesArr{
    if (!_attributesArr) {
        _attributesArr = [NSMutableArray array];
    }
    return _attributesArr;
}

- (NSMutableArray *)columnMaxY{
    if (!_columnMaxY) {
        _columnMaxY = [NSMutableArray array];
        for (int i = 0; i < colNumbers; i ++) {
            [_columnMaxY addObject:@(edgeInset.top)];
        }
    }
    return _columnMaxY;
}

- (void)prepareLayout{
    
    [super prepareLayout];
    
    [self.attributesArr removeAllObjects];
    
    for (int i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        
        NSIndexPath *path = [NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:path];
        
        [self.attributesArr addObject:attr];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attributesArr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    // 获取3列中最小的Y值
    CGFloat minY = [self.columnMaxY[0] floatValue];
    // 获取需要插入的列号
    NSInteger minCol = 0;
    for (int i = 1; i < self.columnMaxY.count; i++) {
        // 计算插入那一列
        if ([self.columnMaxY[i] floatValue] < minY) {
            minY = [self.columnMaxY[i] floatValue];
            minCol = i;
        }
        
    }
    CGFloat W = (self.collectionView.bounds.size.width - edgeInset.left - edgeInset.right - (colNumbers - 1) * colMargin) / colNumbers;
    
    // 如果设置成框架，则高度的设置应该设计成代理方法，由外界决定
    CGFloat H = 50 + arc4random_uniform(100);
    CGFloat X = edgeInset.left + minCol * (W + colMargin);
    CGFloat Y = minY == edgeInset.top ? minY : minY + rowMargin;
    
    attr.frame = CGRectMake(X, Y, W, H);
    
    // 保存插入item后的Y值
    self.columnMaxY[minCol] = @(CGRectGetMaxY(attr.frame));
    
    
    return attr;
}


- (CGSize)collectionViewContentSize{
    // 获取3列中最大的Y值，用于计算contentSize
    CGFloat maxY = [self.columnMaxY[0] floatValue];
    
    for (int i = 1; i < self.columnMaxY.count; i++) {
        // 计算contentSize
        if ([self.columnMaxY[i] floatValue] > maxY) {
            maxY = [self.columnMaxY[i] floatValue];
        }
    }
    
    return CGSizeMake(0, maxY + edgeInset.bottom);
}
@end
