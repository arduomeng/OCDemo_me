//
//  CSDownloadManager.h
//  视频边下边播
//
//  Created by arduomeng on 17/2/16.
//  Copyright © 2017年 arduomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@class CSDownloadManager;
@protocol CSDownloadManagerDelegate <NSObject>

/**
 * Start load data(pass data-length and data-mineType).
 * 开始下载数据(传递长度和类型)
 */
- (void)manager:(CSDownloadManager *)manager didReceiveVideoLength:(NSUInteger)videoLength mimeType:(NSString *)mimeType;

/**
 * It is loading file from network(pass the data received and downloaded position and the path of temporary file)
 * 正在下载(传递获取到的数据和下载的偏移量)
 */
-(void)manager:(CSDownloadManager *)manager didReceiveData:(NSData *)data downloadOffset:(NSInteger)offset;

/**
 * Finished load(pass the save path of file).
 * 完成下载(传递文件的路径)
 */
- (void)didFinishLoadingWithManager:(CSDownloadManager *)manager fileSavePath:(NSString *)filePath;

/**
 * Fail load(pass error).
 * 下载失败(传递错误码)
 */
- (void)didFailLoadingWithManager:(CSDownloadManager *)manager WithError:(NSError *)errorCode;

/*
 移除请求数组
 */
- (void)removeLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest;

@end

@interface CSDownloadManager : NSObject

// URL
@property (nonatomic, strong, readonly) NSURL *url;

// 视频资源请求
@property (nonatomic, strong) AVAssetResourceLoadingRequest *loadingRequest;

// 视频存储路径
@property (nonatomic, strong, readonly) NSString *videoPath;

/**
 * 下载位置的偏移量
 */
@property (nonatomic, readonly) NSUInteger offset;

/**
 * 文件总长度
 */
@property (nonatomic, readonly) NSUInteger fileTotalLength;

/**
 * 当前下载了的文件的位置
 */
@property (nonatomic, readonly) NSUInteger downLoadingOffset;

/**
 * mineType 类型
 */
@property (nonatomic, strong, readonly) NSString *mineType;

/**
 * 查询是否已经下载完成
 */
@property (nonatomic, assign)BOOL isFinishLoad;

/**
 * 成为代理, 就能获得下载状态
 */
@property(nonatomic, weak)id<CSDownloadManagerDelegate> delegate;

/**
 * 视频路径的 scheme
 */
@property(nonatomic, strong)NSString *scheme;

//- (void)setUrl:(NSURL *)url offset:(long long)offset;
- (void)setResourceLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest;
@end
