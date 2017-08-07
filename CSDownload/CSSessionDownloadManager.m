                //
//  CSDownloadManager.m
//  多任务断点下载
//
//  Created by arduomeng on 17/2/28.
//  Copyright © 2017年 arduomeng. All rights reserved.
//

/*
 
下载管理类：现了NSUrlSession相关的代理，并在代理方法中判断对应的dataTask执行相应操作
 
 tips:
 A download can be resumed only if the following conditions are met:
 The resource has not changed since you first requested it
 The task is an HTTP or HTTPS GET request
 The server provides either the ETag or Last-Modified header (or both) in its response
 The server supports byte-range requests
 The temporary file hasn’t been deleted by the system in response to disk space pressure
 
 
 */

#import "AFNetworking.h"
#import "CSSessionDownloadManager.h"
#import "CSSessionDownload.h"
#import "CSUtil.h"
// 最大任务数量
static NSInteger maxConcurrentOperationCount = 3;

@interface CSSessionDownloadManager () <NSURLSessionDataDelegate>

@property (nonatomic, strong) AFHTTPSessionManager *mgr;

@end

@implementation CSSessionDownloadManager

CSSingletonM

#pragma mark Framework Function


//    download.materialInf = self.materialInf;
//    download.materialStoreType = self.materialStoreType;
//    download.isUpdate = self.isUpdate;


- (CSSessionDownload *)downloadDataWithURL:(NSURL *)URL desPath:(NSString *)desPath resume:(BOOL)resume progress:(progressBlock)progressBlock status:(statusBlock)statusBlock{
    
    NSURLSessionDownloadTask *downloadTask;
    NSString *plistDirectory = [[CSUtil documentDirectory] stringByAppendingPathComponent:@"CSSessionPlist"];
    [CSUtil createDirectoryIfNotExists:plistDirectory];
    
    CSSessionDownload *download = [[CSSessionDownload alloc] init];
    
    if (resume) {
        
        NSRange range = [desPath rangeOfString:@"/" options:NSBackwardsSearch];
        if (range.location == NSNotFound) {
            NSLog(@"desPath is invalid");
            return nil;
        }
        if (![self canResumeTaskWithURL:URL]) return nil;
        
        NSString *fileName = [[desPath substringFromIndex:range.location + range.length] componentsSeparatedByString:@"."].firstObject;
        download.plistFilePath = [plistDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]];
        download.resumeData = [NSData dataWithContentsOfFile:download.plistFilePath];
        download.progressBlock = progressBlock;
        download.statusBlock = statusBlock;
        download.desPath = desPath;
        download.currentURL = URL;
        download.downloadTask = downloadTask;
        
        download.tag = self.tag;
        
        
        // 断点下载
        NSString *tmpFile = [[CSUtil tmpDirectory] stringByAppendingPathComponent:[self getTmpFileNameWithDownloadModel:download]];
        BOOL isTmpFileExist = [CSUtil fileExists:tmpFile];
        if (download.resumeData.length && isTmpFileExist) {
            
            downloadTask = [self.mgr downloadTaskWithResumeData:download.resumeData progress:nil destination:nil completionHandler:nil];
            download.downloadTask = downloadTask;
        }
        // 新任务下载
        else{
            
            download.resumeData = nil;
            [[NSFileManager defaultManager] removeItemAtPath:download.plistFilePath error:nil];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
            request.timeoutInterval = 10;
            
            downloadTask = [self.mgr downloadTaskWithRequest:request progress:nil destination:nil completionHandler:nil];
            download.downloadTask = downloadTask;
            
        }
        
        // 添加任务对象到字典 参考AFN将一个task对应一个CSDownload对象管理
        self.downloadDic[URL] = download;
        
        [self resumeTask:download];
    }else{
        
        if (![self canCancelTaskWithURL:URL]) return nil;
        
        download = self.downloadDic[URL];
        [self cancelTask:download];
        
    }
    
    return download;
}

#pragma mark Private Function
- (CSSessionDownload *)getDownloadWithTask:(NSURLSessionTask *)dataTask{
    
    if (self.downloadDic[dataTask.currentRequest.URL]) {
        return self.downloadDic[dataTask.currentRequest.URL];
    }else{
        return nil;
    }
}

- (void)removeDownloadWithFileURL:(NSURL *)fileURL{
    [self.downloadDic removeObjectForKey:fileURL];
}

// 存储下载进度
-(void)setValuesForDownload:(CSSessionDownload *)download withProgress:(double)progress{
    
    NSTimeInterval interval = -1 * [download.downloadDate timeIntervalSinceNow];
    download.totalBytesWritten = download.downloadTask.countOfBytesReceived;
    download.totalBytesExpectedToWrite = download.downloadTask.countOfBytesExpectedToReceive;
    download.downloadProgress = progress;
    download.downloadSpeed = (int64_t)((download.totalBytesWritten - [self getResumeByteWithDownload:download]) / interval);
    
}

// 获取resumeData信息
-(int64_t)getResumeByteWithDownload:(CSSessionDownload *)download{
    int64_t resumeBytes = 0;
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:download.plistFilePath];
    if (dict) {
        resumeBytes = [dict[@"NSURLSessionResumeBytesReceived"] longLongValue];
    }
    return resumeBytes;
}
// 获取TempFile信息
-(NSString *)getTmpFileNameWithDownloadModel:(CSSessionDownload *)download{
    NSString *fileName = nil;
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:download.plistFilePath];
    if (dict) {
        fileName = dict[@"NSURLSessionResumeInfoTempFileName"];
    }
    return fileName;
}

-(BOOL)canResumeTaskWithURL:(NSURL *)url{
    if (self.downloadDic[url]) {
        return NO;
    }
    return YES;
}

- (BOOL)canCancelTaskWithURL:(NSURL *)url{
    if (!self.downloadDic[url]) {
        return NO;
    }
    return YES;
}

// 删除resumeData plist文件
- (void)deletePlistFileWithDownload:(CSSessionDownload *)download{
    [[NSFileManager defaultManager] removeItemAtPath:download.plistFilePath error:nil];
}


#pragma mark Concurrent Task

- (void)resumeTask:(CSSessionDownload *)download{
    
    NSURLSessionDownloadTask *downloadTask = download.downloadTask;
    if (self.taskArr.count < maxConcurrentOperationCount) {
        [self.taskArr addObject:downloadTask];
        
        download.downloadDate = [NSDate date];
        [downloadTask resume];
    }else{
        [self.taskWaitArr addObject:downloadTask];
    }
}

- (void)cancelTask:(CSSessionDownload *)download{
    
    NSURLSessionDownloadTask *downloadTask = download.downloadTask;
    NSURLSessionTaskState state = downloadTask.state;
    if (state == NSURLSessionTaskStateRunning) {
        [downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            download.resumeData = resumeData;
            BOOL isSuc = [download.resumeData writeToFile:download.plistFilePath atomically:YES];
            if (isSuc) {
                
            }
        }];
    }
}

- (void)removeTask:(CSSessionDownload *)download{
    
    NSURLSessionDownloadTask *downloadTask = download.downloadTask;
    [self.taskArr removeObject:downloadTask];
    
    if (self.taskWaitArr.count) {
        NSURLSessionDownloadTask *downloadTask = self.taskWaitArr.firstObject;
        
        [self.taskArr addObject:downloadTask];
        [downloadTask resume];
        
        [self.taskWaitArr removeObject:downloadTask];
    }
    
}
#pragma mark Lazy

- (AFHTTPSessionManager *)mgr{
    if (!_mgr) {
        _mgr = [AFHTTPSessionManager manager];
        _mgr.securityPolicy.allowInvalidCertificates = YES;
        _mgr.securityPolicy.validatesDomainName = NO;
        
        __weak typeof(self) weakSelf = self;
        
        [_mgr setDownloadTaskDidFinishDownloadingBlock:^NSURL * _Nullable(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, NSURL * _Nonnull location) {
            
            // 1.事件传递
            CSSessionDownload *download = [weakSelf getDownloadWithTask:downloadTask];
            
            if (download && download.desPath) {
                // 2.公共处理部分
                NSURL *fileURL = [NSURL fileURLWithPath:download.desPath];
                if (fileURL) {
                    NSError *error = nil;
                    
                    [[NSFileManager defaultManager] removeItemAtURL:fileURL error:nil];
                    
                    if (![[NSFileManager defaultManager] moveItemAtURL:location toURL:fileURL error:&error]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:AFURLSessionDownloadTaskDidFailToMoveFileNotification object:downloadTask userInfo:error.userInfo];
                    }
                }
            }
            
            return nil;
        }];
        
        [_mgr setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
            // 1.事件传递
            CSSessionDownload *download = [weakSelf getDownloadWithTask:downloadTask];
            
            // 2.公共处理部分
            /*
             三：
             resumeData 应用关闭时无法获取resumData并保存
             间隔固定时间，将resumeData进行存储
             */
            float progress = 1.0 * totalBytesWritten / totalBytesExpectedToWrite;
            [weakSelf setValuesForDownload:download withProgress:progress];
            
            // 3.代理
            if (download && download.tag) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    if (!download.isRequestStart) {
                        download.isRequestStart = YES;
                        
                        if ([weakSelf.delegate respondsToSelector:@selector(CSSessionDownloadManagerDidReceiveResponse:download:)]) {
                            [weakSelf.delegate CSSessionDownloadManagerDidReceiveResponse:(NSHTTPURLResponse *)downloadTask.response download:download];
                        }
                        
                        if ([weakSelf.delegate respondsToSelector:@selector(CSSessionDownloadManagerDidRequestStart:)]) {
                            [weakSelf.delegate CSSessionDownloadManagerDidRequestStart:download];
                        }
                    }
                    if ([weakSelf.delegate respondsToSelector:@selector(CSSessionDownloadManagerDidReceiveProgress:download:)]) {
                        
                        [weakSelf.delegate CSSessionDownloadManagerDidReceiveProgress:progress download:download];
                    }
                }];
            }
            
        }];
        
        [_mgr setTaskDidCompleteBlock:^(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSError * _Nullable error) {
            
            // 1.事件传递
            CSSessionDownload *download = [weakSelf getDownloadWithTask:task];
            
            // 2.公共处理部分
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                [weakSelf removeTask:download];
                
                if (!error) {
                    [weakSelf deletePlistFileWithDownload:download];
                }else{
                    /*
                     NSURLSessionDownloadTaskResumeData key in the userInfo dictionary contains a resumeData object.
                     */
                    if ([error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData]) {
                        NSData *resumeData = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
                        download.resumeData = resumeData;
                        BOOL isSuc = [download.resumeData writeToFile:download.plistFilePath atomically:YES];
                        if (isSuc) {
                            
                        }
                    }
                }
                
                // 移除任务字典
                [weakSelf removeDownloadWithFileURL:task.currentRequest.URL];
                
            }];
            // 3.代理
            if (download && download.tag) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    if (!error) {
                        if ([weakSelf.delegate respondsToSelector:@selector(CSSessionDownloadManagerDidRequestFinish:)]) {
                            [weakSelf.delegate CSSessionDownloadManagerDidRequestFinish:download];
                        }
                        
                    }else{
                        if ([weakSelf.delegate respondsToSelector:@selector(CSSessionDownloadManagerDidRequestFail:)]) {
                            [weakSelf.delegate CSSessionDownloadManagerDidRequestFail:download];
                        }
                    }
                }];
            }
            
            
        }];
        
    }
    return _mgr;
}


- (NSURLSession *)session{
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    }
    return _session;
}


- (NSMutableDictionary *)downloadDic{
    if (!_downloadDic) {
        _downloadDic = [NSMutableDictionary dictionary];
    }
    return _downloadDic;
}

- (NSMutableArray *)taskArr{
    if (!_taskArr) {
        _taskArr = [NSMutableArray array];
    }
    return _taskArr;
}

- (NSMutableArray *)taskWaitArr{
    if (!_taskWaitArr) {
        _taskWaitArr = [NSMutableArray array];
    }
    
    return _taskWaitArr;
    
}

/*
 如果你不再需要一个session了, 一定要调用它的invalidateAndCancel或finishTasksAndInvalidate方法. 
 (前者是取消所有未完成的任务然后使session失效, 后者是等待正在执行的任务完成之后再使session失效). 
 否则的话, 有可能造成内存泄漏. 另外, session失效后会调用URLSession:didBecomeInvalidWithError:方法, 之后session释放对代理的强引用.
 */
- (void)invalidateAndCancel{
    [self.session invalidateAndCancel];
}


- (void)removeFileWith:(NSString *)desPath{
    
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:desPath error:&error];

    if (!error) {
        NSLog(@"remove success %@", desPath);

    }else{
        NSLog(@"remove error %@", error);
    }
}

@end
