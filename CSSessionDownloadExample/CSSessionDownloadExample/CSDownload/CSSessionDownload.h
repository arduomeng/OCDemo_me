//
//  CSDownload.h
//  多任务断点下载
//
//  Created by arduomeng on 17/2/28.
//  Copyright © 2017年 arduomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CSConstant.h"

#import "Util.h"


typedef void(^progressBlock)(CGFloat progress);
typedef void(^statusBlock)(CSDownloadStatus status, NSError *error);

@interface CSSessionDownload : NSObject

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, copy)   progressBlock progressBlock;
@property (nonatomic, copy)   statusBlock statusBlock;
// 下载目标地址
@property (nonatomic, copy) NSString *desPath;
// URL
@property (nonatomic, strong) NSURL *currentURL;
@property (nonatomic, assign) BOOL isRequestStart;
@property (nonatomic, strong) id tag;

// resumeData
@property (nonatomic, strong) NSData *resumeData;
// resumeData存储路径
@property (nonatomic, copy) NSString *plistFilePath;
// 起始时间
@property (nonatomic, strong) NSDate *downloadDate;
/* number of body bytes already received */
@property (nonatomic, assign) int64_t totalBytesWritten;
/* number of byte bytes we expect to receive, usually derived from the Content-Length header of an HTTP response. */
@property (nonatomic, assign) int64_t totalBytesExpectedToWrite;
// 进度
@property (nonatomic, assign) double downloadProgress;
// 速度
@property (nonatomic, assign) int64_t downloadSpeed;

#if 0
#pragma mark Custom Property
@property (assign, nonatomic) MaterialStoreType materialStoreType;
@property (nonatomic, strong) MaterialInf *materialInf;

@property (nonatomic, assign) BOOL isUpdate;
#endif

@end
