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

@implementation CSDownload


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    
    NSOutputStream *outputStream = [NSOutputStream outputStreamToFileAtPath:_desPath append:YES];
    [outputStream open];
    self.outputStream = outputStream;
    
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    
    NSURL *requestURL = dataTask.originalRequest.URL;
    [self.outputStream write:[data bytes] maxLength:data.length];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (self.progressBlock) {
            self.progressBlock(1.0 * [CSDownload getFileLength:_desPath] / [CSDownload getFileTotalLength:requestURL]);
        }
    }];
    
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{

    [self.outputStream close];
    self.outputStream = nil;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (self.statusBlock) {
            if (error) {
                self.statusBlock(CSDownloadStatusFailed, error);
            }else{
                self.statusBlock(CSDownloadStatusCompleted, nil);
            }
        }
    }];
}



+ (NSInteger)getFileLength:(NSString *)fileStr{
    NSInteger fileLength = [[[NSFileManager defaultManager] attributesOfItemAtPath:fileStr error:nil][NSFileSize] integerValue];
    return fileLength ? fileLength : 0;
}

+ (NSInteger)getFileTotalLength:(NSURL *)fileURL{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:fileDicFullPath];
    if (dic && dic[fileURL.absoluteString]) {
        return [dic[fileURL.absoluteString] integerValue];
    }else{
        return 0;
    }
}

//- (NSString *)getFileFullPath:(NSString *)fileStr{
//    //文件全路径 并用md5进行加密，保证文件名唯一
//    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[CSConstant md5:fileStr]];
//}


@end
