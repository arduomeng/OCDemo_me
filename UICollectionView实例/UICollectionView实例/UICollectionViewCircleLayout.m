//
//  UICollectionViewCircleLayout.m
//  UICollectionView实例
//
//  Created by LCS on 16/5/1.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "UICollectionViewCircleLayout.h"

@interface UICollectionViewCircleLayout ()

@property (nonatomic, strong) NSMutableArray *attributesArr;

@end

@implementation UICollectionViewCircleLayout

- (NSMutableArray *)attributesArr{
    if (!_attributesArr) {
        _attributesArr = [NSMutableArray array];
    }
    return _attributesArr;
}
// 在该方法中一次性初始化完全部item的UICollectionViewLayoutAttributes
// 在UICollectionViewLineLayout布局的方式中，layoutAttributesForElementsInRect只修改了rect范围中的item

- (void)prepareLayout{
    
    NSLog(@"prepareLayout");
    [super prepareLayout];
    
    [self.attributesArr removeAllObjects];
    
    for (int i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        
        NSIndexPath *path = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attr = nil;
        // 如果只有一个item则居中显示
        if ([self.collectionView numberOfItemsInSection:0] == 1) {
            // 获取indexPath对应的UICollectionViewLayoutAttributes
            attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];
            
            // 设置UICollectionViewLayoutAttributes
            attr.size = CGSizeMake(50, 50);
            
            CGFloat oX = self.collectionView.frame.size.width * 0.5;
            CGFloat oY = self.collectionView.frame.size.height * 0.5;
            
            attr.center = CGPointMake(oX, oY);
        }else{
            attr = [self layoutAttributesForItemAtIndexPath:path];
        }
        
        [self.attributesArr addObject:attr];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    NSLog(@"layoutAttributesForElementsInRect");
    return self.attributesArr;
}
// 当需要collectionView切换布局样式的时候，需要实现该方法。UICollectionViewFlowLayout布局默认实现了该方法。
// 该类是继承UICollectionViewLayout，因此当布局样式切换成该样式的时候，需要实现该方法
// 该方法需要返回indexPath位置对应的cell的局部属性UICollectionViewLayoutAttributes
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CGFloat radius = 100;
    CGFloat oX = self.collectionView.frame.size.width * 0.5;
    CGFloat oY = self.collectionView.frame.size.height * 0.5;
    // 获取indexPath对应的UICollectionViewLayoutAttributes
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // 设置UICollectionViewLayoutAttributes
    attr.size = CGSizeMake(50, 50);
    
    CGFloat angle = 2 * M_PI / [self.collectionView numberOfItemsInSection:0] * indexPath.item;
    CGFloat X = oX + sinf(angle) * radius;
    CGFloat Y = oY + cosf(angle) * radius;
    
    attr.center = CGPointMake(X, Y);
    
    return attr;
}


- (CGSize)collectionViewContentSize{
    return  CGSizeMake(0, 1000);
}
@end
