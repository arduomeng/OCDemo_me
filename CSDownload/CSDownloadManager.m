                //
//  CSDownloadManager.m
//  多任务断点下载
//
//  Created by arduomeng on 17/2/28.
//  Copyright © 2017年 arduomeng. All rights reserved.
//

/*
 
下载管理类：现了NSUrlSession相关的代理，并在代理方法中判断对应的dataTask执行相应操作
 
 */

#import "CSDownloadManager.h"
#import "AFNetworking.h"

// 最大任务数量
static NSInteger maxConcurrentOperationCount = 3;

@interface CSDownloadManager () <NSURLSessionDataDelegate>

@property (nonatomic, strong) AFHTTPSessionManager *mgr;

@end

@implementation CSDownloadManager

CSSingletonM

#pragma mark Framework Function
- (CSDownload *)downloadDataWithURL:(NSURL *)URL desPath:(NSString *)desPath resume:(BOOL)resume progress:(progressBlock)progressBlock status:(statusBlock)statusBlock{
    
    // 1.判断文件是否下载完成
    NSInteger fileLength = [CSDownload getFileLength:desPath];
    
    if (fileLength && [CSDownload getFileTotalLength:URL] == fileLength) {
        // 文件下载完成
        NSLog(@"文件已经下载");
        
        if (progressBlock && statusBlock) {
            progressBlock(1.0);
            statusBlock(CSDownloadStatusCompleted, nil);
        }
        
        return nil;
    }
    
    // 判断任务是否在任务字典
    CSDownload *originalDownload = self.downloadDic[URL];
    if (originalDownload) {
        if (resume) {
            [self resumeTask:originalDownload.dataTask];
        }else{
            [self pauseTask:originalDownload.dataTask];
        }
        
        return originalDownload;
    }
    
    // 未完成且不在任务字典中则开启下载
    NSURLSessionDataTask *dataTask;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    //设置请求头
    if (fileLength) {
        NSString *range = [NSString stringWithFormat:@"bytes=%ld-%ld", (long)fileLength, (long)[CSDownload getFileTotalLength:URL]];
        [request setValue:range forHTTPHeaderField:@"Range"];
    }
    request.timeoutInterval = 60;
    
    dataTask = [self.mgr dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:nil];
//    dataTask = [self.session dataTaskWithRequest:request];
    
    // 添加任务对象到字典 参考AFN将一个task对应一个CSDownload对象管理
    CSDownload *download = [[CSDownload alloc] init];
    download.dataTask = dataTask;
    download.progressBlock = progressBlock;
    download.statusBlock = statusBlock;
    download.desPath = desPath;
    download.currentURL = URL;
    
    self.downloadDic[URL] = download;
    
    if (resume) {
        [self resumeTask:dataTask];
    }else{
        [self pauseTask:dataTask];
    }
    
    return download;
}


- (CSDownload *)getDownloadWithTask:(NSURLSessionTask *)dataTask{
    return self.downloadDic[dataTask.originalRequest.URL];
}


- (void)removeDownloadWithFileURL:(NSURL *)fileURL{
    [self.downloadDic removeObjectForKey:fileURL];
}

- (void)removeFileWith:(NSString *)fileStr{
//    NSError *error;
//    [[NSFileManager defaultManager] removeItemAtPath:[self getFileFullPath:fileStr] error:&error];
//    
//    if (!error) {
//        NSLog(@"remove success %@", fileStr);
//        
//        [self removeDownloadWithFileURL:[NSURL URLWithString:fileStr]];
//    }else{
//        NSLog(@"remove error %@", error);
//    }
}

#pragma mark 任务并发

- (void)resumeTask:(NSURLSessionDataTask *)dataTask{
    
    if (self.taskArr.count < maxConcurrentOperationCount) {
        [self.taskArr addObject:dataTask];
        [dataTask resume];
    }else{
        [self.taskWaitArr addObject:dataTask];
    }
}

- (void)pauseTask:(NSURLSessionDataTask *)dataTask{
    
    [self.taskArr removeObject:dataTask];
    
    if (self.taskWaitArr.count) {
        NSURLSessionDataTask *task = self.taskWaitArr.firstObject;
        
        [self.taskArr addObject:task];
        [task resume];
        
        [self.taskWaitArr removeObject:task];
    }
}

- (void)cancelTask:(NSURLSessionDataTask *)dataTask{
    
    [self.taskArr removeObject:dataTask];
    
    if (self.taskWaitArr.count) {
        NSURLSessionDataTask *task = self.taskWaitArr.firstObject;
        
        [self.taskArr addObject:task];
        [task resume];
        
        [self.taskWaitArr removeObject:task];
    }
}

#pragma mark Lazy

- (AFHTTPSessionManager *)mgr{
    if (!_mgr) {
        _mgr = [AFHTTPSessionManager manager];
        _mgr.securityPolicy.allowInvalidCertificates = YES;
        _mgr.securityPolicy.validatesDomainName = NO;
        
        __weak typeof(self) weakSelf = self;
        
        [_mgr setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
            
            NSHTTPURLResponse *Tresponse = (NSHTTPURLResponse *)response;
            // 1.事件传递
            // 获取dataTask对应的download对象
            CSDownload *download = [weakSelf getDownloadWithTask:dataTask];
            // 参考AFN 将代理方法传递给对应的Download管理
            [download URLSession:session dataTask:dataTask didReceiveResponse:Tresponse completionHandler:nil];
            
            // 2.公共处理部分
            // 文件总长度 ＝ 此次将要下载的长度 ＋ 文件已下载的长度
            NSInteger fileTotalLength = [Tresponse.allHeaderFields[@"Content-Length"] integerValue]; //+ [CSDownload getFileLength:download.desPath];
            
            // 存储文件长度
            NSMutableDictionary *fileDic = [NSMutableDictionary dictionaryWithContentsOfFile:fileDicFullPath];
            
            if (!fileDic) {
                fileDic = [NSMutableDictionary dictionary];
            }
            
            fileDic[dataTask.originalRequest.URL.absoluteString] = @(fileTotalLength);
            
            // If an array or dictionary contains objects that are not property-list objects, then you cannot save and restore the hierarchy of data using the various property-list methods and functions.
            // 注意writeToFile只能写入property-list类型对象 不能是自定义对象或者nil
            // 坑 : fileDic[requestURL] = @(fileTotalLength); key为NSURL类型导致写入失败
            [fileDic writeToFile:fileDicFullPath atomically:YES];
            
            // 3.代理
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if ([weakSelf.delegate respondsToSelector:@selector(CSDownloadManagerDidReceiveResponse:download:)]) {
                    [weakSelf.delegate CSDownloadManagerDidReceiveResponse:Tresponse download:download];
                }
            }];
            
            return NSURLSessionResponseAllow;
        }];
        [_mgr setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
            // 1.事件传递
            CSDownload *download = [weakSelf getDownloadWithTask:dataTask];
            [download URLSession:session dataTask:dataTask didReceiveData:data];
            
            // 2.公共处理部分
            // 3.代理
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (!download.isRequestStart) {
                    download.isRequestStart = YES;
                    
                    if ([weakSelf.delegate respondsToSelector:@selector(CSDownloadManagerDidRequestStart:)]) {
                        [weakSelf.delegate CSDownloadManagerDidRequestStart:download];
                    }
                }
                if ([weakSelf.delegate respondsToSelector:@selector(CSDownloadManagerDidReceiveProgress:download:)]) {
                    float progress = 1.0 * [CSDownload getFileLength:download.desPath] / [CSDownload getFileTotalLength:dataTask.currentRequest.URL];
                    [weakSelf.delegate CSDownloadManagerDidReceiveProgress:progress download:download];
                }
            }];
        }];
        [_mgr setTaskDidCompleteBlock:^(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSError * _Nullable error) {
            // 1.事件传递
            CSDownload *download = [weakSelf getDownloadWithTask:task];
            [download URLSession:session task:task didCompleteWithError:error];
            
            // 2.代理
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (!error) {
                    if ([weakSelf.delegate respondsToSelector:@selector(CSDownloadManagerDidRequestFinish:)]) {
                        [weakSelf.delegate CSDownloadManagerDidRequestFinish:download];
                    }
                }else{
                    if ([weakSelf.delegate respondsToSelector:@selector(CSDownloadManagerDidRequestFail:)]) {
                        [weakSelf.delegate CSDownloadManagerDidRequestFail:download];
                    }
                }
                // 3.公共处理部分
                // 移除下载任务
                [weakSelf cancelTask:(NSURLSessionDataTask *)task];
                // 移除任务字典
                [weakSelf removeDownloadWithFileURL:task.originalRequest.URL];
                
            }];
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


#pragma mark NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    NSURLCredential *credential = nil;
    
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        if (credential) {
            disposition = NSURLSessionAuthChallengeUseCredential;
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
        
    } else {
        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    }
    
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    
    // 1.事件传递
    // 获取dataTask对应的download对象
    CSDownload *download = [self getDownloadWithTask:dataTask];
    // 参考AFN 将代理方法传递给对应的Download管理
    [download URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
    
    // 2.公共处理部分
    // 文件总长度 ＝ 此次将要下载的长度 ＋ 文件已下载的长度
    NSInteger fileTotalLength = [response.allHeaderFields[@"Content-Length"] integerValue]; //+ [CSDownload getFileLength:download.desPath];
    
    // 存储文件长度
    NSMutableDictionary *fileDic = [NSMutableDictionary dictionaryWithContentsOfFile:fileDicFullPath];
    
    if (!fileDic) {
        fileDic = [NSMutableDictionary dictionary];
    }
    
    fileDic[dataTask.originalRequest.URL.absoluteString] = @(fileTotalLength);
    
    // If an array or dictionary contains objects that are not property-list objects, then you cannot save and restore the hierarchy of data using the various property-list methods and functions.
    // 注意writeToFile只能写入property-list类型对象 不能是自定义对象或者nil
    // 坑 : fileDic[requestURL] = @(fileTotalLength); key为NSURL类型导致写入失败
    [fileDic writeToFile:fileDicFullPath atomically:YES];
    
    // 3.代理
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if ([self.delegate respondsToSelector:@selector(CSDownloadManagerDidReceiveResponse:download:)]) {
            [self.delegate CSDownloadManagerDidReceiveResponse:response download:download];
        }
    }];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    // 1.事件传递
    CSDownload *download = [self getDownloadWithTask:dataTask];
    [download URLSession:session dataTask:dataTask didReceiveData:data];
    
    // 2.公共处理部分
    // 3.代理
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (!download.isRequestStart) {
            download.isRequestStart = YES;
            
            if ([self.delegate respondsToSelector:@selector(CSDownloadManagerDidRequestStart:)]) {
                [self.delegate CSDownloadManagerDidRequestStart:download];
            }
        }
        if ([self.delegate respondsToSelector:@selector(CSDownloadManagerDidReceiveProgress:download:)]) {
            float progress = 1.0 * [CSDownload getFileLength:download.desPath] / [CSDownload getFileTotalLength:dataTask.currentRequest.URL];
            [self.delegate CSDownloadManagerDidReceiveProgress:progress download:download];
        }
    }];
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    // 1.事件传递
    CSDownload *download = [self getDownloadWithTask:task];
    [download URLSession:session task:task didCompleteWithError:error];
    
    // 2.代理
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (!error) {
            if ([self.delegate respondsToSelector:@selector(CSDownloadManagerDidRequestFinish:)]) {
                [self.delegate CSDownloadManagerDidRequestFinish:download];
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(CSDownloadManagerDidRequestFail:)]) {
                [self.delegate CSDownloadManagerDidRequestFail:download];
            }
        }
        // 3.公共处理部分
        // 移除下载任务
        [self cancelTask:(NSURLSessionDataTask *)task];
        // 移除任务字典
        [self removeDownloadWithFileURL:task.originalRequest.URL];
        
    }];
    
}

/*
 如果你不再需要一个session了, 一定要调用它的invalidateAndCancel或finishTasksAndInvalidate方法. 
 (前者是取消所有未完成的任务然后使session失效, 后者是等待正在执行的任务完成之后再使session失效). 
 否则的话, 有可能造成内存泄漏. 另外, session失效后会调用URLSession:didBecomeInvalidWithError:方法, 之后session释放对代理的强引用.
 */
- (void)invalidateAndCancel{
    [self.session invalidateAndCancel];
}




@end
