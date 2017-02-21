//
//  CSResourceLoader.h
//  视频边下边播
//
//  Created by arduomeng on 17/2/15.
//  Copyright © 2017年 arduomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "CSDownloadManager.h"
@class CSResourceLoader;
@protocol CSResourceLoaderDelegate <NSObject>

- (void)didFailLoadingWithResourceLoader:(CSResourceLoader *)resourceLoader;

@end

@interface CSResourceLoader : NSObject <AVAssetResourceLoaderDelegate>

/**
 The download tool for video file.
 *下载器
 */
@property (nonatomic, strong)CSDownloadManager *manager;

/**
 * The request queue.
 * It save the request wait for being given video data.
 * 请求队列
 */
@property (nonatomic, strong)NSMutableArray *pendingRequests;


/**
 * File name.
 * 文件名
 */
@property(nonatomic, strong)NSString *suggestFileName;

@property (nonatomic, weak) id <CSResourceLoaderDelegate> delegate;

@end
