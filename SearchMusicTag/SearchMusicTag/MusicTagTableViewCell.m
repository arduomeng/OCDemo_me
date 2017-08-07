//
//  MusicTagTableViewCell.m
//  SearchMusicTag
//
//  Created by user on 2017/5/31.
//  Copyright © 2017年 user. All rights reserved.
//

#import "MusicTagTableViewCell.h"
#import "UIView+Extensions.h"
#import "UIView+AutoLayout.h"

#define kTagMarginLR 10
#define kTagMarginW 10
#define kTagMarginUD 5
#define kTagMarginH 5

@implementation MusicTagTableViewCell


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    
}

- (void)setMusicTagsArr:(NSArray *)musicTagsArr section:(NSInteger) section{
    
    _musicTagsArr = musicTagsArr;
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < _musicTagsArr.count; i++) {
        
        NSString *title = _musicTagsArr[i];
        if (title) {
            MusicTagButton *btn = [self buttonWithTitle:title];
            btn.tag = i;
            btn.section = section;
            btn.title = title;
            
            [self.contentView addSubview:btn];
        }
    }
    
    NSUInteger currentX = kTagMarginLR;
    NSUInteger currentY = kTagMarginUD;
    
    for (int i = 0; i < self.contentView.subviews.count; i++) {
        
        UIView *subView = self.contentView.subviews[i];
        
        if ([subView isKindOfClass:[MusicTagButton class]]) {
            
            if (subView.width > [UIScreen mainScreen].bounds.size.width - 2 * kTagMarginLR) {
                subView.width = [UIScreen mainScreen].bounds.size.width - 2 * kTagMarginLR;
            }
            if (currentX + subView.width + kTagMarginLR > [UIScreen mainScreen].bounds.size.width) {
                [subView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kTagMarginLR];
                [subView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:(1 * (subView.height + kTagMarginH) + currentY)];
                [subView autoSetDimension:ALDimensionWidth toSize:subView.width];
                [subView autoSetDimension:ALDimensionHeight toSize:subView.height];
                currentY = (1 * (subView.height + kTagMarginH) + currentY);
                currentX = kTagMarginLR + subView.width + kTagMarginW;
            }else{
                [subView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:currentX];
                [subView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:currentY];
                [subView autoSetDimension:ALDimensionWidth toSize:subView.width];
                [subView autoSetDimension:ALDimensionHeight toSize:subView.height];
                currentX = currentX + subView.width + kTagMarginW;
            }
            
            if (i == self.contentView.subviews.count - 1) {
                [subView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTagMarginUD];
            }
        }
        
    }
    
}

- (MusicTagButton *)buttonWithTitle:(NSString *)title{
    
    MusicTagButton *btn = [[MusicTagButton alloc] init];
    [btn addTarget:self action:@selector(buttonOnclick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor blueColor];
    btn.layer.cornerRadius = 3;
    btn.clipsToBounds = YES;
    btn.contentEdgeInsets = UIEdgeInsetsMake(7, 10, 7, 10);
    [btn sizeToFit];
    
    
    return btn;
}


- (void)buttonOnclick:(MusicTagButton *)button{

    [self.delegate musicTagTableViewCell:self OnclickButton:button];
}

@end
