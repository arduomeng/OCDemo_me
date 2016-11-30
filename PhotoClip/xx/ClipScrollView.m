//
//  ClipScrollView.m
//  xx
//
//  Created by arduomeng on 16/11/16.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import "ClipScrollView.h"
#import "UIImage+Extension.h"
@interface ClipScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ClipScrollView

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image{
    if (self = [super initWithFrame:frame]){
        
        _image = image;
        _imageView = [[UIImageView alloc] init];
        _imageView.image = image;
        [self addSubview:_imageView];
        
        // 根据图片宽高比设置imageView frame
        // 获取图片尺寸计算frame
        float ratio = image.size.width / image.size.height;
        float imageW = 0;
        float imageH = 0;
        if (image.size.width >= image.size.height) {
            imageW = frame.size.width;
            imageH = imageW / ratio;
            // 设置contentInset
            float insetMargin = (frame.size.height - imageH) * 0.5;
            self.contentInset = UIEdgeInsetsMake(insetMargin, 0, insetMargin, 0);
        }else{
            imageH = frame.size.height;
            imageW = imageH * ratio;
            // 设置contentInset
            float insetMargin = (frame.size.width - imageW) * 0.5;
            self.contentInset = UIEdgeInsetsMake(0, insetMargin, 0, insetMargin);
        }
        
        // 设置imageView frame
        _imageView.frame = CGRectMake(0, 0, imageW, imageH);
        
        self.delegate = self;
        
    }
    
    return self;
}

- (void)beginClip{
    
    // 设置缩放比例
    self.minimumZoomScale = 1;
    self.maximumZoomScale = 2;
    
    // 修改imageView frame
    float ratio = _image.size.width / _image.size.height;
    float imageW = 0;
    float imageH = 0;
    if (_image.size.width < _image.size.height) {
        imageW = self.frame.size.width;
        imageH = imageW / ratio;
    }else{
        imageH = self.frame.size.height;
        imageW = imageH * ratio;
    }
    // 设置imageView frame
    _imageView.hidden = YES;
    _imageView.frame = CGRectMake(0, 0, imageW, imageH);
    
    _imageView.transform = CGAffineTransformMakeScale(0, 0);
    _imageView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _imageView.transform = CGAffineTransformIdentity;
    }];
    
    self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    // 修改scrollView contentSize
    self.contentSize = _imageView.frame.size;
    
}

- (UIImage *)getClipImage{
    // 获得裁剪区域
    CGRect rec = CGRectMake(self.contentOffset.x, self.contentOffset.y, self.bounds.size.width, self.bounds.size.height);
    
    // 获取image
    UIImage *resizeImage = [UIImage scaleToSize:_image size:CGSizeMake(_imageView.frame.size.width, _imageView.frame.size.height)];
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([resizeImage CGImage],rec);
    UIImage *clipImage = [[UIImage alloc] initWithCGImage:imageRef];
    
    return clipImage;
}

- (void)resetView{
    // 根据图片宽高比设置imageView frame
    // 获取图片尺寸计算frame
    float ratio = _image.size.width / _image.size.height;
    float imageW = 0;
    float imageH = 0;
    if (_image.size.width >= _image.size.height) {
        imageW = self.frame.size.width;
        imageH = imageW / ratio;
        // 设置contentInset
        float insetMargin = (self.frame.size.height - imageH) * 0.5;
        self.contentInset = UIEdgeInsetsMake(insetMargin, 0, insetMargin, 0);
    }else{
        imageH = self.frame.size.height;
        imageW = imageH * ratio;
        // 设置contentInset
        float insetMargin = (self.frame.size.width - imageW) * 0.5;
        self.contentInset = UIEdgeInsetsMake(0, insetMargin, 0, insetMargin);
    }
    
    // 设置imageView frame
    _imageView.frame = CGRectMake(0, 0, imageW, imageH);
    self.contentSize = CGSizeZero;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    // 设置contentInset 使缩小时候图片居中
    // 计算缩放时候的offset
    // 注意缩放时frame的值变化，而bounds的值不变。且系统会将scrollView的contentSize设置为该frame
    
    float offsetX = (self.frame.size.width - _imageView.frame.size.width) * 0.5;
    float offsetY = (self.frame.size.height - _imageView.frame.size.height) * 0.5;
    
    // 当iamgeview放大时，防止offset出现负值导致无法滚动
    offsetX = offsetX < 0 ? 0 : offsetX;
    offsetY = offsetY < 0 ? 0 : offsetY;
    
    self.contentInset = UIEdgeInsetsMake(offsetY, offsetX, offsetY, offsetX);
    
}




/*
- (void)drawRect:(CGRect)rect {
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    // contentInset的偏移值
    float offsetX = self.contentInset.left;
    float offsetY = self.contentInset.top;
    
    CGContextRef ctr = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] set];
    CGContextSetLineWidth(ctr, 1);
    // 网格线
    UIBezierPath *pathH1 = [UIBezierPath bezierPath];
    [pathH1 moveToPoint:CGPointMake(0 - offsetX, height / 3 - offsetY)];
    [pathH1 addLineToPoint:CGPointMake(width - offsetX, height / 3 - offsetY)];
    CGContextAddPath(ctr, pathH1.CGPath);
    CGContextStrokePath(ctr);
    
    UIBezierPath *pathH2 = [UIBezierPath bezierPath];
    [pathH2 moveToPoint:CGPointMake(0 - offsetX, height / 3 * 2 - offsetY)];
    [pathH2 addLineToPoint:CGPointMake(width - offsetX, height / 3 * 2 - offsetY)];
    CGContextAddPath(ctr, pathH2.CGPath);
    CGContextStrokePath(ctr);
    
    UIBezierPath *pathV1 = [UIBezierPath bezierPath];
    [pathV1 moveToPoint:CGPointMake(width / 3 - offsetX, 0 - offsetY)];
    [pathV1 addLineToPoint:CGPointMake(width / 3 - offsetX, height - offsetY)];
    CGContextAddPath(ctr, pathV1.CGPath);
    CGContextStrokePath(ctr);
    
    UIBezierPath *pathV2 = [UIBezierPath bezierPath];
    [pathV2 moveToPoint:CGPointMake(width / 3 * 2 - offsetX, 0 - offsetY)];
    [pathV2 addLineToPoint:CGPointMake(width / 3 * 2 - offsetX, height - offsetY)];
    CGContextAddPath(ctr, pathV2.CGPath);
    CGContextStrokePath(ctr);
    
    
}
 */

@end
