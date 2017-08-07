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
#import "CSDownload.h"


@protocol CSDownloadManagerDelegate <NSObject>

- (void)CSDownloadManagerDidReceiveResponse:(NSHTTPURLResponse *)response download:(CSDownload *)download ;
- (void)CSDownloadManagerDidRequestStart:(CSDownload *)download;
- (void)CSDownloadManagerDidReceiveProgress:(float)progress download:(CSDownload *)download;
- (void)CSDownloadManagerDidRequestFail:(CSDownload *)download;
- (void)CSDownloadManagerDidRequestFinish:(CSDownload *)download;
- (void)CSDownloadManagerDidQueueFinish:(CSDownload *)download;

@end

@interface CSDownloadManager : NSObject

CSSingletonH

#pragma mark Framework Property


@property (nonatomic, strong) NSURLSession *session;
// 任务字典
@property (nonatomic, strong) NSMutableDictionary *downloadDic;
// 代理
@property (nonatomic, weak) id delegate;
// 任务数组
@property (nonatomic, strong) NSMutableArray *taskArr;
// 等待任务数组
@property (nonatomic, strong) NSMutableArray *taskWaitArr;


- (CSDownload *)downloadDataWithURL:(NSURL *)URL desPath:(NSString *)desPath resume:(BOOL)resume progress:(progressBlock)progressBlock status:(statusBlock)statusBlock;
- (void)removeFileWith:(NSString *)fileStr;

@end
