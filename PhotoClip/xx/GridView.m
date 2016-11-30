//
//  GridView.m
//  xx
//
//  Created by arduomeng on 16/11/16.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import "GridView.h"

@interface GridView ()

@property (nonatomic, strong) UIView *gridH1;
@property (nonatomic, strong) UIView *gridH2;
@property (nonatomic, strong) UIView *gridV1;
@property (nonatomic, strong) UIView *gridV2;

@end

@implementation GridView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        float width = self.frame.size.width;
        float height = self.frame.size.height;
        
        _gridH1 = [[UIView alloc] init];
        _gridH1.backgroundColor = [UIColor redColor];
        _gridH1.frame = CGRectMake(0, height / 3, width, 1);
        [self addSubview:_gridH1];
        _gridH2 = [[UIView alloc] init];
        _gridH2.backgroundColor = [UIColor redColor];
        _gridH2.frame = CGRectMake(0, height / 3 * 2, width, 1);
        [self addSubview:_gridH2];
        _gridV1 = [[UIView alloc] init];
        _gridV1.backgroundColor = [UIColor redColor];
        _gridV1.frame = CGRectMake(width / 3, 0, 1, height);
        [self addSubview:_gridV1];
        _gridV2 = [[UIView alloc] init];
        _gridV2.backgroundColor = [UIColor redColor];
        _gridV2.frame = CGRectMake(width / 3 * 2, 0, 1, height);
        [self addSubview:_gridV2];
        
        self.userInteractionEnabled = NO;
    }
    
    return self;
}


@end
