//
//  NSGif.h
//  VideoShow
//
//  Created by Mac on 2017/6/6.
//  Copyright © 2017年 energy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <ImageIO/ImageIO.h>
#import <AVFoundation/AVFoundation.h>
#import "CSSingleton.h"

#if TARGET_OS_IPHONE
#import <MobileCoreServices/MobileCoreServices.h>
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <CoreServices/CoreServices.h>
#import <WebKit/WebKit.h>
#endif


@interface NSGif : NSObject

@property (nonatomic,copy) void(^progressBlock)(float progress);
@property (nonatomic,copy) void(^successBlock)(NSURL *GifURL);
@property (nonatomic,copy) void(^failureBlock)(NSError *error);
@property (nonatomic,assign) BOOL isCancel;

CSSingletonH

- (void)optimalGIFfromURL:(NSURL*)videoURL loopCount:(int)loopCount completion:(void(^)(NSURL *GifURL))completionBlock;

- (void)createGIFfromURL:(NSURL*)videoURL withFrameCount:(int)frameCount delayTime:(float)delayTime loopCount:(int)loopCount progress:(void(^)(float progress))progressBlock success:(void(^)(NSURL *GifURL))successBlock failure:(void(^)(NSError *error))failureBlock;

@end
