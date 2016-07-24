//
//  ViewController.m
//  文件断点下载完整
//
//  Created by LCS on 16/4/18.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "ViewController.h"
#import "WTUtil.h"

//文件全路径 并用md5进行加密，保证文件名唯一
#define fileFullPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[WTUtil md5:fileURL]]
//文件大小存储字典 记录需下载文件的大小，判断文件是否下载完成
#define fileDicFullPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"fileDic.plist"]

#define fileURL @"http://120.25.226.186:32812/resources/videos/minion_01.mp4"

// 根据NSFileSize 获取已下载文件的大小
#define fileLength [[[NSFileManager defaultManager] attributesOfItemAtPath:fileFullPath error:nil][NSFileSize] integerValue]

@interface ViewController () <NSURLSessionDataDelegate>

@property (nonatomic, assign) NSInteger fileTotalLength;

@property (nonatomic, strong) NSOutputStream *outputStream;
@property (nonatomic, strong) NSURLSessionDataTask *task;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@end

@implementation ViewController

- (NSOutputStream *)outputStream{
    if (!_outputStream) {
        
        _outputStream = [NSOutputStream outputStreamToFileAtPath:fileFullPath append:YES];
        
    }
    return _outputStream;
}

- (NSURLSessionDataTask *)task{
    if (!_task) {
        
        //判断文件是否下载完成
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:fileDicFullPath];
        if (fileLength && [dic[fileURL] integerValue] == fileLength) {
            
            NSLog(@"文件已经下载");
            
            return nil;
        }
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:fileURL]];
        //设置请求头
        NSString *range = [NSString stringWithFormat:@"bytes=%ld-", fileLength];
        
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        _task = [session dataTaskWithRequest:request];
        
    }
    return _task;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", fileFullPath);
    
}
- (IBAction)start:(id)sender {
    
    [self.task resume];
    
}
- (IBAction)pause:(id)sender {
    
    [self.task suspend];
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    
    [self.outputStream open];
    
    // 文件总长度 ＝ 此次将要下载的长度 ＋ 文件已下载的长度
    _fileTotalLength = [response.allHeaderFields[@"Content-Length"] integerValue] + fileLength;
    
    //存储文件长度
    NSMutableDictionary *fileDic = [NSMutableDictionary dictionaryWithContentsOfFile:fileDicFullPath];
    
    if (!fileDic) {
        fileDic = [NSMutableDictionary dictionary];
    }
    
    fileDic[fileURL] = @(_fileTotalLength);
    
    [fileDic writeToFile:fileDicFullPath atomically:YES];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.outputStream write:[data bytes] maxLength:data.length];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        _progressView.progress = 1.0 * fileLength / _fileTotalLength;
    }];
    
    NSLog(@"%f", 1.0 * fileLength / _fileTotalLength);
}



- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    [_outputStream close];
    _outputStream = nil;
}


@end
