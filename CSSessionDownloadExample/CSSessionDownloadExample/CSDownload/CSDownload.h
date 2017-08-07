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

@interface CSDownload : NSObject

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, copy)   progressBlock progressBlock;
@property (nonatomic, copy)   statusBlock statusBlock;
@property (nonatomic, strong) NSOutputStream *outputStream;
@property (nonatomic, copy) NSString *desPath;
@property (nonatomic, strong) NSURL *currentURL;
@property (nonatomic, assign) BOOL isRequestStart;
@property (nonatomic, assign) id tag;


#pragma mark Custom Property
#if 0
@property (assign, nonatomic) MaterialStoreType materialStoreType;
@property (nonatomic, strong) MaterialInf *materialInf;

@property (nonatomic, assign) BOOL isUpdate;
#endif
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler;
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data;
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error;

// 已下载文件长度
+ (NSInteger)getFileLength:(NSString *)fileStr;
// 文件总长度
+ (NSInteger)getFileTotalLength:(NSURL *)fileURL;
@end
