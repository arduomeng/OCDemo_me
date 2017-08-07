//
//  CSDownloadManager.h
//  多任务断点下载
//
//  Created by arduomeng on 17/2/28.
//  Copyright © 2017年 arduomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CSSingleton.h"
#import "CSSessionDownload.h"


@protocol CSSessionDownloadManagerDelegate <NSObject>

@optional
- (void)CSSessionDownloadManagerDidReceiveResponse:(NSHTTPURLResponse *)response download:(CSSessionDownload *)download ;
- (void)CSSessionDownloadManagerDidRequestStart:(CSSessionDownload *)download;
- (void)CSSessionDownloadManagerDidReceiveProgress:(float)progress download:(CSSessionDownload *)download;
- (void)CSSessionDownloadManagerDidRequestFail:(CSSessionDownload *)download;
- (void)CSSessionDownloadManagerDidRequestFinish:(CSSessionDownload *)download;
- (void)CSSessionDownloadManagerDidQueueFinish:(CSSessionDownload *)download;

@end

@interface CSSessionDownloadManager : NSObject

CSSingletonH

#pragma mark Framework Property
@property (nonatomic, strong) NSURLSession *session;
// 任务字典
@property (nonatomic, strong) NSMutableDictionary *downloadDic;
// 代理
@property (nonatomic, weak) id <CSSessionDownloadManagerDelegate> delegate;
// 任务数组
@property (nonatomic, strong) NSMutableArray <NSURLSessionDownloadTask *>*taskArr;
// 等待任务数组
@property (nonatomic, strong) NSMutableArray <NSURLSessionDownloadTask *>*taskWaitArr;
// id
@property (nonatomic, strong) id tag;

#pragma mark Custom Property
#if 0
@property (assign, nonatomic) MaterialStoreType materialStoreType;
@property (nonatomic, strong) MaterialInf *materialInf;

@property (nonatomic, assign) BOOL isUpdate;
#endif

- (CSSessionDownload *)downloadDataWithURL:(NSURL *)URL desPath:(NSString *)desPath resume:(BOOL)resume progress:(progressBlock)progressBlock status:(statusBlock)statusBlock;
- (void)removeFileWith:(NSString *)fileStr;

@end
