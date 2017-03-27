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
#import "WTUtil.h"

//文件大小存储字典 记录需下载文件的大小，判断文件是否下载完成
#define fileDicFullPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"fileDic.plist"]

@interface CSDownloadManager () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;
// 任务字典
@property (nonatomic, strong) NSMutableDictionary *downloadDic;

@end

@implementation CSDownloadManager

CSSingletonM

- (void)downloadDataWithURL:(NSURL *)URL resume:(BOOL)resume progress:(void(^)(CGFloat progress))progressBlock status:(void(^)(CSDownloadStatus status))statusBlock{
    
    // 判断文件是否下载完成
    NSInteger fileLength = [self getFileLength:URL];
    
    if (fileLength && [self getFileTotalLength:URL] == fileLength) {
        // 文件下载完成
        NSLog(@"文件已经下载");
        
        progressBlock(1.0);
        statusBlock(CSDownloadStatusCompleted);
    }
    
    // 判断任务是否在任务字典
    CSDownload *originalDownload = self.downloadDic[URL];
    if (originalDownload) {
        if (resume) {
            [originalDownload.dataTask resume];
        }else{
            [originalDownload.dataTask suspend];
        }
        
        return;
    }
    
    // 未完成且不在任务字典中则开启下载
    NSURLSessionDataTask *dataTask;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    //设置请求头
    NSString *range = [NSString stringWithFormat:@"bytes=%ld-", fileLength];
    [request setValue:range forHTTPHeaderField:@"Range"];
    dataTask = [self.session dataTaskWithRequest:request];
    
    // 添加任务对象到字典 参考AFN将一个task对应一个CSDownload对象管理
    CSDownload *download = [[CSDownload alloc] init];
    download.dataTask = dataTask;
    download.progressBlock = progressBlock;
    download.statusBlock = statusBlock;
    
    self.downloadDic[URL] = download;
    
    if (resume) {
        [dataTask resume];
    }
}

- (NSString *)getFileFullPath:(NSString *)fileStr{
    //文件全路径 并用md5进行加密，保证文件名唯一
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[WTUtil md5:fileStr]];
}

- (CSDownload *)getDownloadWithTask:(NSURLSessionTask *)dataTask{
    return self.downloadDic[dataTask.originalRequest.URL];
}

- (NSInteger)getFileLength:(NSURL *)fileURL{
    NSInteger fileLength = [[[NSFileManager defaultManager] attributesOfItemAtPath:[self getFileFullPath:[fileURL absoluteString]] error:nil][NSFileSize] integerValue];
    return fileLength ? fileLength : 0;
}

- (NSInteger)getFileTotalLength:(NSURL *)fileURL{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:fileDicFullPath];
    if (dic && dic[fileURL.absoluteString]) {
        return [dic[fileURL.absoluteString] integerValue];
    }else{
        return 0;
    }
}

- (void)removeDownloadWithFileURL:(NSURL *)fileURL{
    [self.downloadDic removeObjectForKey:fileURL.absoluteString];
}

#pragma mark NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    
    // 1.代理进行传递
    // 获取dataTask对应的download对象
    CSDownload *download = [self getDownloadWithTask:dataTask];
    // 参考AFN 将代理方法传递给对应的Download管理
    [download URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
    
    // 2.公共处理部分
    // 文件总长度 ＝ 此次将要下载的长度 ＋ 文件已下载的长度
    NSInteger fileTotalLength = [response.allHeaderFields[@"Content-Length"] integerValue] + [self getFileLength:dataTask.originalRequest.URL];
    
    //存储文件长度
    NSMutableDictionary *fileDic = [NSMutableDictionary dictionaryWithContentsOfFile:fileDicFullPath];
    
    if (!fileDic) {
        fileDic = [NSMutableDictionary dictionary];
    }
    
    fileDic[dataTask.originalRequest.URL.absoluteString] = @(fileTotalLength);
    
    // If an array or dictionary contains objects that are not property-list objects, then you cannot save and restore the hierarchy of data using the various property-list methods and functions.
    // 注意writeToFile只能写入property-list类型对象 不能是自定义对象或者nil
    // 坑 : fileDic[requestURL] = @(fileTotalLength); key为NSURL类型导致写入失败
    [fileDic writeToFile:fileDicFullPath atomically:YES];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    // 1.代理进行传递
    CSDownload *download = [self getDownloadWithTask:dataTask];
    [download URLSession:session dataTask:dataTask didReceiveData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    // 1.代理进行传递
    CSDownload *download = [self getDownloadWithTask:task];
    [download URLSession:session task:task didCompleteWithError:error];
    
    // 2.公共处理部分
    // 移除任务字典
    [self removeDownloadWithFileURL:task.originalRequest.URL];
    
}

#pragma mark Lazy
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

@end
