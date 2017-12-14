//
//  ViewController.m
//  53NSURLSession－01
//
//  Created by Mac OS X on 15/9/21.
//  Copyright (c) 2015年 Mac OS X. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <NSURLSessionDownloadDelegate>

- (IBAction)btnDownloadClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIProgressView *progress;

//task 任务
@property (nonatomic, strong) NSURLSessionDownloadTask *task;
//resumeData 下一次下载的开始位置
@property (nonatomic, strong) NSData *resumeData;
//session
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation ViewController


#pragma mark - session的懒加载
- (NSURLSession *)session
{
    if (_session == nil) {
        
        NSURLSessionConfiguration *cgr = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        //[NSOperationQueue mainQueue] 表示completionHandler和代理方法在哪个队列执行，一般下载完后回住队列执行。
        _session = [NSURLSession sessionWithConfiguration:cgr delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
    }
    return _session;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

/*
 NSURLSessionDataTask:普通的GET／POST请求
 NSURLSessionDownloadTask:文件下载
 NSURLSessionUploadTask:文件上传
 
 */

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self downloadTask2];
}

#pragma mark -NSURLSessionDownloadTask

// NSURLSession *session = [NSURLSession sharedSession];
//completionHandler    下载任务完成后调用
-(void) downloadTask
{
    //1.得到一个session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/MJServer/resources/videos/minion_01.mp4"];
    
    //2.创建一个downloadTask，任务.一边下载一边写沙盒
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
       
        //location:临时文件的路径（下载好的文件），默认是tmp文件夹，会自动删除，所以需要剪切走
        NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        //response.suggestedFilename为服务器中原文件名
        NSString *path = [cache stringByAppendingPathComponent:response.suggestedFilename];
        
        //将临时文件剪切到caches文件夹
        NSFileManager *mgr = [NSFileManager defaultManager];
        
        [mgr moveItemAtPath:location.path toPath:path error:nil];
        
       
    }];
    
    //3.开始任务
    [task resume];
}
/*
 NSURLSession *session = [NSURLSession sessionWithConfiguration:cgr delegate:self delegateQueue:[NSOperationQueue mainQueue]];
 可以设置代理方法
 */
//sessionWithConfiguration通过设置代理，代理可以实现：      下载完成，下载进度，断点续传
- (void) downloadTask2
{
    //1.得到session
    //2.创建一个下载任务
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/MJServer/resources/mp4s.zip"];
    NSURLSessionDownloadTask *task = [self.session downloadTaskWithURL:url];
    
    //如果给下载任务设置了completionhandler 这个block， 也实现了下载的代理方法，优先执行block
    
    //3.开始任务
    [task resume];
}

#pragma mark - NSURLSessionDownloadDelegate

//下载完毕调用
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"didFinishDownloadingToURL");
    
    //完成之后进行剪切
    //location:临时文件的路径（下载好的文件），默认是tmp文件夹，会自动删除，所以需要剪切走
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    //response.suggestedFilename为服务器中原文件名
    NSString *path = [cache stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    
    //将临时文件剪切到caches文件夹
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    [mgr moveItemAtPath:location.path toPath:path error:nil];
}
//恢复下载时调用
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}
//每当下载完一部分调用
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    double progress = (double)totalBytesWritten / totalBytesExpectedToWrite;
//    NSLog(@"%f", progress);
    self.progress.progress = progress;
}



#pragma mark -  NSURLSessionDataTask:普通的GET／POST请求
- (void) dataTask
{
    //1.得到一个session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //2.创建一个task，任务
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/MJServer/video"];
    
    //dataTaskWithURL
    //    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    //
    //        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    //        NSLog(@"%@",json);
    //
    //    }];
    //    [task resume];
    
    
    //dataTaskWithURL
    
    url = [NSURL URLWithString:@"http://localhost:8080/MJServer/login"];
    
    //创建一个请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [@"username=123&pwd=123" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dict);
    }];
    
    
    
    [task resume];
}

//点击按钮实现断点续传
- (IBAction)btnDownloadClick:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    
    if (sender.selected) {//正在下载
        if (self.resumeData) { //有值说明，是断点续传
            [self resume];
        }else//第一次下载
        {
            [self start];
        }
    }else{
        [self pause];
    }
    
}

- (void) resume
{
    //传入上次暂停下载返回的数据，就可以恢复下载
    self.task = [self.session downloadTaskWithResumeData:self.resumeData];
    
    //开始任务
    [self.task resume];
    
    self.resumeData = nil;
}

-(void) start
{
    //1.得到NSURLSession对象
    
    //2.创建一个下载任务
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/MJServer/resources/mp4s.zip"];
    
    self.task = [self.session downloadTaskWithURL:url];
    
    
    //如果给下载任务设置了completionhandler 这个block， 也实现了下载的代理方法，优先执行block
    
    //3.开始任务
    [self.task resume];
}

- (void)pause
{
    //代码块中引用了外部的对象，所以需要weak修饰
    __weak typeof(self) vc = self;
    [self.task cancelByProducingResumeData:^(NSData *resumeData) {//resumeData内部包含了，下一次继续下载的开始位置,还包含了下载url
        vc.resumeData = resumeData;
        vc.task = nil;
    }];
}


@end
