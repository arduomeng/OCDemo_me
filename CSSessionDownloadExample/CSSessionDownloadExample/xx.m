//
//  xx.m
//  CSSessionDownloadExample
//
//  Created by user on 2017/5/16.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma mark - download methods

#if 0
-(void)fk_startDownloadWithDownloadModel:(FKNetworkingDownloadModel *)downloadModel
progress:(void (^)(FKNetworkingDownloadModel * _Nonnull))progress
completionHandler:(void (^)(FKNetworkingDownloadModel * _Nonnull, NSError * _Nullable))completionHandler{
    
    NSString *fileName = [downloadModel.fileName componentsSeparatedByString:@"."].firstObject;
    downloadModel.fileDirectory = [self.downloadDirectory stringByAppendingPathComponent:fileName];
    downloadModel.filePath = [[self.downloadDirectory stringByAppendingPathComponent:fileName] stringByAppendingPathComponent:downloadModel.fileName];
    downloadModel.plistFilePath = [downloadModel.fileDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]];
    
    if (![self canBeStartDownloadTaskWithDownloadModel:downloadModel]) return;
    
    downloadModel.resumeData = [NSData dataWithContentsOfFile:downloadModel.plistFilePath];
    
    if (downloadModel.resumeData.length == 0) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadModel.resourceURLString]];
        downloadModel.downloadTask = [self.AFManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            
            [self setValuesForDownloadModel:downloadModel withProgress:downloadProgress.fractionCompleted];
            progress(downloadModel);
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            
            return [NSURL fileURLWithPath:downloadModel.filePath];
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (error) {
                [self fk_cancelDownloadTaskWithDownloadModel:downloadModel];
                completionHandler(downloadModel, error);
            }else{
                [self.downloadModelsDict removeObjectForKey:downloadModel.resourceURLString];
                completionHandler(downloadModel, nil);
                [self deletePlistFileWithDownloadModel:downloadModel];
            }
        }];
        
    }else{
        
        downloadModel.progressModel.totalBytesWritten = [self getResumeByteWithDownloadModel:downloadModel];
        downloadModel.downloadTask = [self.AFManager downloadTaskWithResumeData:downloadModel.resumeData progress:^(NSProgress * _Nonnull downloadProgress) {
            
            [self setValuesForDownloadModel:downloadModel withProgress:[self.AFManager downloadProgressForTask:downloadModel.downloadTask].fractionCompleted];
            progress(downloadModel);
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL fileURLWithPath:downloadModel.filePath];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (error) {
                [self fk_cancelDownloadTaskWithDownloadModel:downloadModel];
                completionHandler(downloadModel, error);
            }else{
                [self.downloadModelsDict removeObjectForKey:downloadModel.resourceURLString];
                completionHandler(downloadModel, nil);
                [self deletePlistFileWithDownloadModel:downloadModel];
            }
        }];
    }
    
    if (![self.fileManager fileExistsAtPath:self.downloadDirectory]) {
        [self.fileManager createDirectoryAtPath:self.downloadDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [self createFolderAtPath:[self.downloadDirectory stringByAppendingPathComponent:fileName]];
    [self fk_resumeDownloadWithDownloadModel:downloadModel];
}

-(void)fk_resumeDownloadWithDownloadModel:(FKNetworkingDownloadModel *)downloadModel{
    if (downloadModel.downloadTask) {
        downloadModel.downloadDate = [NSDate date];
        [downloadModel.downloadTask resume];
        self.downloadModelsDict[downloadModel.resourceURLString] = downloadModel;
        [self.downloadingModels addObject:downloadModel];
    }
}

-(void)fk_cancelDownloadTaskWithDownloadModel:(FKNetworkingDownloadModel *)downloadModel{
    if (!downloadModel) return;
    NSURLSessionTaskState state = downloadModel.downloadTask.state;
    if (state == NSURLSessionTaskStateRunning) {
        [downloadModel.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            downloadModel.resumeData = resumeData;
            @synchronized (self) {
                BOOL isSuc = [downloadModel.resumeData writeToFile:downloadModel.plistFilePath atomically:YES];
                [self saveTotalBytesExpectedToWriteWithDownloadModel:downloadModel];
                if (isSuc) {
                    downloadModel.resumeData = nil;
                    [self.downloadModelsDict removeObjectForKey:downloadModel.resourceURLString];
                    [self.downloadingModels removeObject:downloadModel];
                }
            }
        }];
    }
}

-(void)fk_deleteDownloadedFileWithDownloadModel:(FKNetworkingDownloadModel *)downloadModel{
    if ([self.fileManager fileExistsAtPath:downloadModel.fileDirectory]) {
        [self.fileManager removeItemAtPath:downloadModel.fileDirectory error:nil];
    }
}

-(void)fk_deleteAllDownloadedFiles{
    if ([self.fileManager fileExistsAtPath:self.downloadDirectory]) {
        [self.fileManager removeItemAtPath:self.downloadDirectory error:nil];
    }
}

-(BOOL)fk_hasDownloadedFileWithDownloadModel:(FKNetworkingDownloadModel *)downloadModel{
    if ([self.fileManager fileExistsAtPath:downloadModel.filePath]) {
        NSLog(@"已下载的文件...");
        return YES;
    }
    return NO;
}

-(FKNetworkingDownloadModel *)fk_getDownloadingModelWithURLString:(NSString *)URLString{
    return self.downloadModelsDict[URLString];
}

-(FKNetworkingProgressModel *)fk_getDownloadProgressModelWithDownloadModel:(FKNetworkingDownloadModel *)downloadModel{
    FKNetworkingProgressModel *progressModel = downloadModel.progressModel;
    progressModel.downloadProgress = [self.AFManager downloadProgressForTask:downloadModel.downloadTask].fractionCompleted;
    return progressModel;
}

#pragma mark - private methods
-(BOOL)canBeStartDownloadTaskWithDownloadModel:(FKNetworkingDownloadModel *)downloadModel{
    if (!downloadModel) return NO;
    if (downloadModel.downloadTask && downloadModel.downloadTask.state == NSURLSessionTaskStateRunning) return NO;
    if ([self fk_hasDownloadedFileWithDownloadModel:downloadModel]) return NO;
    return YES;
}

-(void)setValuesForDownloadModel:(FKNetworkingDownloadModel *)downloadModel withProgress:(double)progress{
    NSTimeInterval interval = -1 * [downloadModel.downloadDate timeIntervalSinceNow];
    downloadModel.progressModel.totalBytesWritten = downloadModel.downloadTask.countOfBytesReceived;
    downloadModel.progressModel.totalBytesExpectedToWrite = downloadModel.downloadTask.countOfBytesExpectedToReceive;
    downloadModel.progressModel.downloadProgress = progress;
    downloadModel.progressModel.downloadSpeed = (int64_t)((downloadModel.progressModel.totalBytesWritten - [self getResumeByteWithDownloadModel:downloadModel]) / interval);
    if (downloadModel.progressModel.downloadSpeed != 0) {
        int64_t remainingContentLength = downloadModel.progressModel.totalBytesExpectedToWrite  - downloadModel.progressModel.totalBytesWritten;
        int currentLeftTime = (int)(remainingContentLength / downloadModel.progressModel.downloadSpeed);
        downloadModel.progressModel.downloadLeft = currentLeftTime;
    }
}

-(int64_t)getResumeByteWithDownloadModel:(FKNetworkingDownloadModel *)downloadModel{
    int64_t resumeBytes = 0;
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:downloadModel.plistFilePath];
    if (dict) {
        resumeBytes = [dict[@"NSURLSessionResumeBytesReceived"] longLongValue];
    }
    return resumeBytes;
}

-(NSString *)getTmpFileNameWithDownloadModel:(FKNetworkingDownloadModel *)downloadModel{
    NSString *fileName = nil;
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:downloadModel.plistFilePath];
    if (dict) {
        fileName = dict[@"NSURLSessionResumeInfoTempFileName"];
    }
    return fileName;
}

-(void)createFolderAtPath:(NSString *)path{
    if ([self.fileManager fileExistsAtPath:path]) return;
    [self.fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

-(void)deletePlistFileWithDownloadModel:(FKNetworkingDownloadModel *)downloadModel{
    if (downloadModel.downloadTask.countOfBytesReceived == downloadModel.downloadTask.countOfBytesExpectedToReceive) {
        [self.fileManager removeItemAtPath:downloadModel.plistFilePath error:nil];
        [self removeTotalBytesExpectedToWriteWhenDownloadFinishedWithDownloadModel:downloadModel];
    }
}

-(NSString *)managerPlistFilePath{
    return [self.downloadDirectory stringByAppendingPathComponent:@"ForKidManager.plist"];
}

-(nullable NSMutableDictionary <NSString *, NSString *> *)managerPlistDict{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:[self managerPlistFilePath]];
    return dict;
}

-(void)saveTotalBytesExpectedToWriteWithDownloadModel:(FKNetworkingDownloadModel *)downloadModel{
    NSMutableDictionary <NSString *, NSString *> *dict = [self managerPlistDict];
    [dict setValue:[NSString stringWithFormat:@"%lld", downloadModel.downloadTask.countOfBytesExpectedToReceive] forKey:downloadModel.resourceURLString];
    [dict writeToFile:[self managerPlistFilePath] atomically:YES];
}

-(void)removeTotalBytesExpectedToWriteWhenDownloadFinishedWithDownloadModel:(FKNetworkingDownloadModel *)downloadModel{
    NSMutableDictionary <NSString *, NSString *> *dict = [self managerPlistDict];
    [dict removeObjectForKey:downloadModel.resourceURLString];
    [dict writeToFile:[self managerPlistFilePath] atomically:YES];
}

#pragma mark - share instance
+(FKNetworkingManager *)shareManager{
    static FKNetworkingManager *manager = nil;
    static dispatch_once_t sigletonOnceToken;
    dispatch_once(&sigletonOnceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _AFManager = [[AFHTTPSessionManager alloc]init];
        _AFManager.requestSerializer.timeoutInterval = 5;
        _AFManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;//NSURLRequestUseProtocolCachePolicy;
        NSSet *typeSet = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        _AFManager.responseSerializer.acceptableContentTypes = typeSet;
        _AFManager.securityPolicy.allowInvalidCertificates = YES;
        
        _maxDownloadCount = 1;
        _resumeTaskFIFO = YES;
        _batchDownload = NO;
        _fileManager = [NSFileManager defaultManager];
        _waitingModels = [[NSMutableArray alloc] initWithCapacity:1];
        _downloadingModels = [[NSMutableArray alloc] initWithCapacity:1];
        _downloadModelsDict = [[NSMutableDictionary alloc] initWithCapacity:1];
        
        _downloadDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:FKNetworkingManagerFileName];
        [_fileManager createDirectoryAtPath:_downloadDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        
        NSDictionary <NSString *, NSString *> *plistDict = [[NSDictionary alloc] init];
        NSString *managerPlistFilePath = [_downloadDirectory stringByAppendingPathComponent:@"ForKidManager.plist"];
        [plistDict writeToFile:managerPlistFilePath atomically:YES];
    }
    return self;
}
#endif
