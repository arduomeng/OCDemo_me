//
//  CSDownload.m
//  多任务断点下载
//
//  Created by arduomeng on 17/2/28.
//  Copyright © 2017年 arduomeng. All rights reserved.
//


/*
    
 @property (nonatomic, strong) NSURLSessionDataTask *dataTask;
 @property (nonatomic, copy)   progressBlock progressBlock;
 @property (nonatomic, copy)   statusBlock statusBlock;
 @property (nonatomic, strong) NSOutputStream *outputStream;
 
 一个任务对应一个该对象。 将上述属性统一由该类存储
 
 */
#import "CSDownload.h"
#import "WTUtil.h"


//文件大小存储字典 记录需下载文件的大小，判断文件是否下载完成
#define fileDicFullPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"fileDic.plist"]

@implementation CSDownload


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    
    NSURL *requestURL = dataTask.originalRequest.URL;
    NSString *fileStr = [self getFileFullPath:requestURL.absoluteString];
    NSOutputStream *outputStream = [NSOutputStream outputStreamToFileAtPath:fileStr append:YES];
    [outputStream open];
    self.outputStream = outputStream;
    
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    
    NSURL *requestURL = dataTask.originalRequest.URL;
    [self.outputStream write:[data bytes] maxLength:data.length];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.progressBlock(1.0 * [self getFileLength:requestURL] / [self getFileTotalLength:requestURL]);
    }];
    
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{

    [self.outputStream close];
    self.outputStream = nil;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (error) {
            self.statusBlock(CSDownloadStatusFailed);
        }else{
            self.statusBlock(CSDownloadStatusCompleted);
        }
    }];
}


- (NSString *)getFileFullPath:(NSString *)fileStr{
    //文件全路径 并用md5进行加密，保证文件名唯一
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[WTUtil md5:fileStr]];
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

@end
