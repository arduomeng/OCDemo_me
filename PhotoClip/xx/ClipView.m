//
//  ClipView.m
//  xx
//
//  Created by arduomeng on 16/11/16.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import "ClipView.h"
#import "ClipScrollView.h"
#import "GridView.h"

@interface ClipView ()
@property (nonatomic, strong) ClipScrollView *clipScrollView;
@property (nonatomic, strong) GridView *gridView;
@end

@implementation ClipView

- (GridView *)gridView{
    if (!_gridView) {
        _gridView = [[GridView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self addSubview:_gridView];
        [self bringSubviewToFront:_gridView];
    }
    return _gridView;
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image{
    if (self = [super initWithFrame:frame]) {
        
        _clipScrollView = [[ClipScrollView alloc] initWithFrame:frame image:image];
        [self addSubview:_clipScrollView];
        
        
    }
    
    return self;
}

- (void)beginClip{
    self.gridView.hidden = NO;
    [_clipScrollView beginClip];
}
- (UIImage *)getClipImage{
    return [_clipScrollView getClipImage];
}
- (void)resetView{
    
    self.gridView.hidden = YES;
    [_clipScrollView resetView];
}

@end
