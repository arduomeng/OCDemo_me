//
//  CSResourceLoader.m
//  视频边下边播
//
//  Created by arduomeng on 17/2/15.
//  Copyright © 2017年 arduomeng. All rights reserved.
//

#import "CSResourceLoader.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "Util.h"
@interface CSResourceLoader () <CSDownloadManagerDelegate>

@end

@implementation CSResourceLoader



#pragma mark AVAssetResourceLoaderDelegate
/**
 *  这里会出现很多个loadingRequest请求， 需要为每一次请求作出处理
 *  @param resourceLoader 资源管理器
 *  @param loadingRequest 每一小块数据的请求
 
 播放器发出的数据请求从这里开始，我们保存从这里发出的所有请求存放到数组，自己来处理这些请求，当一个请求完成后，对请求发出finishLoading消息，并从数组中移除。正常状态下，当播放器发出下一个请求的时候，会把上一个请求给finish。
 
 */
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    
    if (resourceLoader && loadingRequest) {
        [self.pendingRequests addObject:loadingRequest];
        [self dealLoadingRequest:loadingRequest];
    }
    
    return YES;
}

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForRenewalOfRequestedResource:(AVAssetResourceRenewalRequest *)renewalRequest {
    return YES;
}

/*
 播放器自己关闭了这个请求，我们不需要再对这个请求进行处理，系统每次结束一个旧的请求，便必然会发出一个或多个新的请求，除了播放器已经获得整个视频完整的数据，这时候就不会再发起请求
 */
- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest{
    [self.pendingRequests removeObject:loadingRequest];
}

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForResponseToAuthenticationChallenge:(NSURLAuthenticationChallenge *)authenticationChallenge{
    return YES;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)authenticationChallenge {
    
}

#pragma mark CSDownloadManagerDelegate

- (void)manager:(CSDownloadManager *)manager didReceiveVideoLength:(NSUInteger)videoLength mimeType:(NSString *)mimeType{
    
}

-(void)manager:(CSDownloadManager *)manager didReceiveData:(NSData *)data downloadOffset:(NSInteger)offset{
    NSLog(@"didReceiveData downingOffset : %ld", offset);
    [self processPendingRequests];
}


- (void)didFinishLoadingWithManager:(CSDownloadManager *)manager fileSavePath:(NSString *)filePath{
    
}

- (void)didFailLoadingWithManager:(CSDownloadManager *)manager WithError:(NSError *)error{
    if ([self.delegate respondsToSelector:@selector(didFailLoadingWithResourceLoader:)]) {
        [self.delegate didFailLoadingWithResourceLoader:self];
    }
}

- (void)removeLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest{
    [self.pendingRequests removeObject:loadingRequest];
}

#pragma mark Private
// 处理请求 下载视频
- (void)dealLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest{
    
    // AVPlayer 会多次调用该方法。若已经开始下载则return
    if (self.manager.downLoadingOffset > 0) {
        return;
    }else{
        [self.manager setResourceLoadingRequest:loadingRequest];
    }
    
}

// 下载管理获取数据回调
- (void)processPendingRequests{
    
    // 遍历所有的请求, 为每个请求加上请求的数据长度和文件类型等信息.
    // 在判断当前下载完的数据长度中有没有要请求的数据, 如果有,就把这段数据取出来,并且把这段数据填充给请求, 然后关闭这个请求
    // 如果没有, 继续等待下载完成.
    
    NSMutableArray *requestsCompleted = [NSMutableArray array];
    for (AVAssetResourceLoadingRequest *loadingRequest in self.pendingRequests) {
        
        [self fillInContentInformation:loadingRequest.contentInformationRequest];
        BOOL didRespondCompletely = [self respondWithDataForRequest:loadingRequest.dataRequest];
        
        if (didRespondCompletely) {
            [requestsCompleted addObject:loadingRequest];
            [loadingRequest finishLoading];
        }
    }
    [self.pendingRequests removeObjectsInArray:[requestsCompleted copy]];
}

// 处理请求，将未读取的视频数据传给播放器
- (BOOL)respondWithDataForRequest:(AVAssetResourceLoadingDataRequest *)dataRequest{
    
    long long currentOffset = dataRequest.requestedOffset;
    
    // 请求过程中当前的offset (请求数据量大时，会多次调用didReceiveData,因此currentOffset纪录本次回调时候的offset)
    if (dataRequest.currentOffset != 0)
        currentOffset = dataRequest.currentOffset;
    
    // 计算未读取的Byte
    NSData *fileData = [NSData dataWithContentsOfFile:_manager.videoPath options:NSDataReadingMappedIfSafe error:nil];
    // 未读取byte数 ＝ 下载成功数 － （请求当前偏移 － 请求初始偏移）
    NSInteger unreadBytes = self.manager.downLoadingOffset - ((NSInteger)currentOffset - self.manager.offset);
    // MIN(请求总长度， 未读byte数) dataRequest.requestedLength 值为 fillInContentInformation方法中 contentLength
    // 实际测试下发现播放器第一次请求时dataRequest.requestedLength ＝ 2
    NSUInteger numberOfBytesToRespondWith = MIN((NSUInteger)dataRequest.requestedLength, unreadBytes);
    // 返回data给播放器
    [dataRequest respondWithData:[fileData subdataWithRange:NSMakeRange((NSUInteger)currentOffset, (NSUInteger)numberOfBytesToRespondWith)]];
   
    // 结束偏移值(视频总长度) ＝ 请求偏移值 ＋ 请求总长度（2 或者 视频总长度）
    long long endOffset = dataRequest.requestedOffset + dataRequest.requestedLength;
    // 请求初始偏移值 ＋ 下载成功数 >= 结束偏移值
    BOOL didRespondFully = (self.manager.offset + self.manager.downLoadingOffset) >= endOffset;
    
    // 当dataRequest.requestedLength = 2 时 return YES;
    return didRespondFully;
}

// 填充Request所需的信息 contentLength
-(void)fillInContentInformation:(AVAssetResourceLoadingContentInformationRequest *)contentInformationRequest{
    NSString *mimetype = self.manager.mineType;
    CFStringRef contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef _Nonnull)(mimetype), NULL);
    contentInformationRequest.byteRangeAccessSupported = YES;
    contentInformationRequest.contentType = CFBridgingRelease(contentType);
    // contentLength : 该请求内容的总长度（一般为视频总长度） : 影响播放器缓冲总长度
    contentInformationRequest.contentLength = self.manager.fileTotalLength;
}

#pragma mark lazy


- (NSMutableArray *)pendingRequests{
    if (!_pendingRequests) {
        _pendingRequests = [NSMutableArray array];
    }
    return _pendingRequests;
}


- (CSDownloadManager *)manager{
    if (!_manager) {
        _manager = [[CSDownloadManager alloc] init];
        _manager.delegate = self;
    }
    return _manager;
}

@end
