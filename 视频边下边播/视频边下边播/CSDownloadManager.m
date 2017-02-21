//
//  CSDownloadManager.m
//  视频边下边播
//
//  Created by arduomeng on 17/2/16.
//  Copyright © 2017年 arduomeng. All rights reserved.
//

#import "CSDownloadManager.h"
#import "WTUtil.h"
#import "Util.h"
#import "CSFileManager.h"
//文件大小存储字典 记录需下载文件的大小，判断文件是否下载完成
#define fileDicFullPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"fileDic.plist"]


@interface CSDownloadManager  () <NSURLSessionDataDelegate>


@property (nonatomic, strong) NSOutputStream *outputStream;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *task;

@end

@implementation CSDownloadManager

#pragma mark Public

/*
- (void)setUrl:(NSURL *)url offset:(long long)offset{
    
    _url = url;
    _offset = offset;
    // Reset
    [_session invalidateAndCancel];
    _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:_url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
    //设置请求头
    NSString *range = [NSString stringWithFormat:@"bytes=%lld-", offset];
    
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    _task = [_session dataTaskWithRequest:request];
    
    [self startLoading];
}
*/
- (void)setResourceLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest{
    
    _loadingRequest = loadingRequest;
    _url = [Util getHttpVideoURL:loadingRequest.request.URL];
    _videoPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:[WTUtil md5:_url.absoluteString]];
    NSString *fileURL = _url.absoluteString;
    // 判断本地是否有缓存文件
    if ([CSFileManager fileExists:_videoPath]) {
        // 判断视频是否完整
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:fileDicFullPath];
        NSInteger fileLength = [[[NSFileManager defaultManager] attributesOfItemAtPath:_videoPath error:nil][NSFileSize] integerValue];
        
        // 将已下载的部分返回给播放器
        // 给loadingRequest添加以下信息
        loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
        //3.1contentType
        loadingRequest.contentInformationRequest.contentType = @"video/mp4";
        //3.2数据长度
        loadingRequest.contentInformationRequest.contentLength = [dic[fileURL] integerValue];
        //3.3请求的偏移量
        long long requestedOffset = loadingRequest.dataRequest.requestedOffset;
        //3.4请求总长度
        NSInteger requestedLength = loadingRequest.dataRequest.requestedLength;
        //3.5取出本地文件中从偏移量到请求长度的数据
        
        NSUInteger numberOfBytesToRespondWith = MIN(requestedLength, fileLength);
        NSData *subData = [[NSData dataWithContentsOfFile:_videoPath] subdataWithRange:NSMakeRange(@(requestedOffset).unsignedIntegerValue, numberOfBytesToRespondWith)];
        //3.6返回数据给请求
        [loadingRequest.dataRequest respondWithData:subData];
        
        // requestedLength == 2 播放器首次请求一些特殊数据 直接finishLoading操作 || 视频文件完整直接finishLoading
        if (requestedLength == 2 || fileLength == [dic[fileURL] integerValue]) {
            
            // 结束请求
            [loadingRequest finishLoading];
            // 移除数组
            if ([self.delegate respondsToSelector:@selector(removeLoadingRequest:)]) {
                [self.delegate removeLoadingRequest:loadingRequest];
            }
            // 文件完整
            if (fileLength && [dic[fileURL] integerValue] == fileLength) {
                NSLog(@"文件已经下载");
            }
            
            return ;
        }else{
            // 下载剩余视频
            _offset = fileLength;
        }
        
    }else{
        // 下载视频
        _offset = 0;
    }
    
    // Reset
    [_session invalidateAndCancel];
    _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:_url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
    //设置请求头
    NSString *range = [NSString stringWithFormat:@"bytes=%ld-", _offset];
    
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    _task = [_session dataTaskWithRequest:request];
    
    [self startLoading];
    
}


//-(void)invalidateAndCancel{
//    [self.session invalidateAndCancel];
//}

- (IBAction)startLoading{
    
    [self.task resume];
    
}
- (IBAction)pauseLoading{
    
    [self.task suspend];
    
}

#pragma mark private


#pragma mark NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    
    [self.outputStream open];
    
    /*
     po response.allHeaderFields
     
     offset = 0 response的值
     {
     "Accept-Ranges" = bytes;
     "Content-Length" = 6109596; // 将要下载的长度
     "Content-Range" = "bytes 0-6109595/6109596"; // range下载范围
     "Content-Type" = "video/mp4";
     Date = "Thu, 16 Feb 2017 06:07:35 GMT";
     Etag = "W/\"6109596-1409456092000\"";
     "Last-Modified" = "Sun, 31 Aug 2014 03:34:52 GMT";
     Server = "Apache-Coyote/1.1";
     }
     
     offset = 100 response的值
     {
     "Accept-Ranges" = bytes;
     "Content-Length" = 6109496;
     "Content-Range" = "bytes 100-6109595/6109596";
     "Content-Type" = "video/mp4";
     Date = "Thu, 16 Feb 2017 06:11:02 GMT";
     Etag = "W/\"6109596-1409456092000\"";
     "Last-Modified" = "Sun, 31 Aug 2014 03:34:52 GMT";
     Server = "Apache-Coyote/1.1";
     }
     */
    
    // 获取文件总长度. 如果响应头里有文件长度数据, 就取这个长度; 如果没有, 就取代理方法返回给我们的长度
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    NSDictionary *dic = (NSDictionary *)[httpResponse allHeaderFields] ;
    NSString *content = [dic valueForKey:@"Content-Range"];
    NSArray *array = [content componentsSeparatedByString:@"/"];
    NSString *length = array.lastObject;
    if ([length integerValue] == 0) {
        _fileTotalLength = (NSUInteger)httpResponse.expectedContentLength;
    }
    else {
        _fileTotalLength = [length integerValue];
    }
    
    _mineType = [dic valueForKey:@"Content-Type"];
    
    // 剩余空间与请求长度的判断
//    if (![self checkDiskFreeSize:fileLength]) {
//        completionHandler(NSURLSessionResponseCancel);
//        return;
//    }
    
    //存储文件长度
    NSMutableDictionary *fileDic = [NSMutableDictionary dictionaryWithContentsOfFile:fileDicFullPath];
    
    if (!fileDic) {
        fileDic = [NSMutableDictionary dictionary];
    }
    
    fileDic[_url.absoluteString] = @(_fileTotalLength);
    
    [fileDic writeToFile:fileDicFullPath atomically:YES];
    
    
    if ([self.delegate respondsToSelector:@selector(manager:didReceiveVideoLength:mimeType:)]) {
        [self.delegate manager:self didReceiveVideoLength:_fileTotalLength mimeType:_mineType];
    }
    
    completionHandler(NSURLSessionResponseAllow);
}

                
                
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    _downLoadingOffset += data.length;
    [self.outputStream write:[data bytes] maxLength:data.length];
    
    if ([self.delegate respondsToSelector:@selector(manager:didReceiveData:downloadOffset:)]) {
        [self.delegate manager:self didReceiveData:data downloadOffset:_downLoadingOffset];
    }
}



- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (!error) { // 下载成功
        [self downloadSuccessWithURLSession:session task:task];
    }
    else{ // 下载失败
        [self downloadFailedWithURLSession:session task:task error:error];
    }
}

#pragma mark Handle Request Finished(Success|Fail)

-(void)downloadSuccessWithURLSession:(NSURLSession *)session task:(NSURLSessionTask *)task{
    
    if ([self.delegate respondsToSelector:@selector(didFinishLoadingWithManager:fileSavePath:)]) {
        [self.delegate didFinishLoadingWithManager:self fileSavePath:_videoPath];
    }
    
    [self.outputStream close];
    self.outputStream = nil;
}

-(void)downloadFailedWithURLSession:(NSURLSession *)session task:(NSURLSessionTask *)task error:(NSError *)error{
    
    //网络中断：-1005
    //无网络连接：-1009
    //请求超时：-1001
    //服务器内部错误：-1004
    //找不到服务器：-1003
    
    if ([self.delegate respondsToSelector:@selector(didFailLoadingWithManager:WithError:)]) {
        [self.delegate didFailLoadingWithManager:self WithError:error];
    }
    
    
}
                
#pragma mark lazy

- (NSOutputStream *)outputStream{
    if (!_outputStream) {
    
        // 断点下载因此不需要删除
        /*
        if ([[NSFileManager defaultManager] fileExistsAtPath:_videoPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:_videoPath error:nil];
        }*/
        _outputStream = [NSOutputStream outputStreamToFileAtPath:_videoPath append:YES];
        
    }
    return _outputStream;
}


//- (NSURLSessionDataTask *)task{
//    if (!_task) {
//        
//        //判断文件是否下载完成
//        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:fileDicFullPath];
//        if (fileLength && [dic[fileURL] integerValue] == fileLength) {
//            
//            NSLog(@"文件已经下载");
//            
//            return nil;
//        }
//        
//        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
//        
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:_url];
//        //设置请求头
//        NSString *range = [NSString stringWithFormat:@"bytes=%ld-", fileLength];
//        
//        [request setValue:range forHTTPHeaderField:@"Range"];
//        
//        _task = [session dataTaskWithRequest:request];
//        
//    }
//    return _task;
//}
@end
