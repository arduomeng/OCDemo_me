//
//  ViewController.m
//  51文件下载
//
//  Created by Mac OS X on 15/9/21.
//  Copyright (c) 2015年 Mac OS X. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <NSURLConnectionDataDelegate>

//@property (nonatomic, strong) NSMutableData *fileData;
@property (nonatomic, assign) long long totalLength;
@property (nonatomic, assign) long long currentLength;
//写数据的文件句柄对象
@property (nonatomic, strong) NSFileHandle *writeHandle;


@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self download3];
}

//小文件下载
- (void) download1
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *url = [NSURL URLWithString:@"http://localhost:8080/MJServer/resources/images/minion_01.png"];
        
        //其实这就是一个get请求
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        NSLog(@"%ld", data.length);
        
        //将文件写入沙盒
        
        
    });
    
}

- (void) download2
{
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/MJServer/resources/images/minion_01.png"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"%ld", data.length);
    }];
}

//大文件下载

- (void) download3
{
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/MJServer/resources/videos/minion_01.mp4"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    //下载。开启异步下载,并且设置代理
    [NSURLConnection connectionWithRequest:request delegate:self];
}


//接受到服务器的响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //获取文件的大小，通过相应头获取
    //简单的获取方式
    //self.totalLength =  response.expectedContentLength ;
    
    //将NSURLResponse强转成NSHTTPURLResponse类型，才能获得相应头信息
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    long long fileLength = [httpResponse.allHeaderFields[@"Content-Length"] longLongValue];
    
    self.totalLength = fileLength;
    
    NSLog(@"%ld", self.totalLength);
    
    //在沙盒中创建一个同样大小的空文件
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *path = [cache stringByAppendingPathComponent:@"text.mp4"];
    
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    
    [mgr createFileAtPath:path contents:nil attributes:nil];
    
    //创建一个该文件的文件句柄操作该文件
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];
    
    self.writeHandle = handle;
    
    
}
//接收到数据时调用
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    self.currentLength += data.length;
    
    //进度条显示
    self.progress.progress = (double)self.currentLength / self.totalLength;
    
    //移动到文件的最后
    [self.writeHandle seekToEndOfFile];
    
    //写入数据
    [self.writeHandle writeData:data];
}

//下载完毕调用
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //关闭文件
    [self.writeHandle closeFile];
    self.writeHandle = nil;
    
    //清空length
    self.currentLength = 0;
    self.totalLength = 0;
    
}

@end
