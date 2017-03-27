//
//  CSDownload.h
//  多任务断点下载
//
//  Created by arduomeng on 17/2/28.
//  Copyright © 2017年 arduomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CSDownloadStatus) {
    CSDownloadStatusRunning,
    CSDownloadStatusSuspended,
    CSDownloadStatusCompleted,
    CSDownloadStatusFailed,
    CSDownloadStatusCancel,
};

typedef void(^progressBlock)(CGFloat progress);
typedef void(^statusBlock)(CSDownloadStatus status);

@interface CSDownload : NSObject

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, copy)   progressBlock progressBlock;
@property (nonatomic, copy)   statusBlock statusBlock;
@property (nonatomic, strong) NSOutputStream *outputStream;

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler;
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data;
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error;

@end
