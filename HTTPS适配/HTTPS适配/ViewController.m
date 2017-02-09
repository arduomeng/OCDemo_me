//
//  ViewController.m
//  HTTPS适配
//
//  Created by arduomeng on 17/2//Users/admin/Desktop/temp/OCDemo_me/HTTPS适配/Podfile6.
//  Copyright © 2017年 arduomeng. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
@interface ViewController () <NSURLSessionDelegate, NSURLSessionDataDelegate>

@end

@implementation ViewController
//NSString *urlString = @"https://www.12306.cn/mormhweb/";
//NSString *urlString = @"https://www.baidu.com";
NSString *urlString = @"https://kyfw.12306.cn/otn/";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self afnRequest];
}

- (void)sessionRequest{
    //1.确定请求路径
    
    NSURL *url= [NSURL URLWithString:urlString];
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //3.创建session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    
    //4.执行task
    [dataTask resume];
}

#pragma mark - NSURLSessionDataDelegate
//只要请求的地址是HTTPS的, 就会调用这个代理方法
//challenge:质询
//NSURLAuthenticationMethodServerTrust:服务器信任
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    NSLog(@"%@",challenge.protectionSpace);
    
    // 判断是否是受信任的证书
    if (![challenge.protectionSpace.authenticationMethod isEqualToString:@"NSURLAuthenticationMethodServerTrust"]){
        
        NSLog(@"---------------------------------------------------------------- 不受信任的证书");
        return;
    }
    /*
     NSURLSessionAuthChallengeUseCredential 使用证书
     NSURLSessionAuthChallengePerformDefaultHandling  忽略证书 默认的做法
     NSURLSessionAuthChallengeCancelAuthenticationChallenge 取消请求,忽略证书
     NSURLSessionAuthChallengeRejectProtectionSpace 拒绝,忽略证书
     */
    
    // 创建证书
    NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    
    // 安装证书
    completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    //5.解析数据
    NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    NSLog(@"---------------------------------------------------------------- error : %@", error);
}

- (void)afnRequest{
    
    
    // /先导入证书
    //    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"srca" ofType:@"cer"];//证书的路径
    //    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    //    NSSet *cerSet = [NSSet setWithObject:certData];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    /* AFSSLPinningModeCertificate 使用证书验证模式
     
     AFSSLPinningModeNone, // 仅验证是否在可信任列表中
     AFSSLPinningModePublicKey, // 公钥验证
     AFSSLPinningModeCertificate, // 证书验证
     */
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//
//    // 如果是需要验证自建证书，需要设置为YES
//    securityPolicy.allowInvalidCertificates = YES;
//    // 如果需要验证域名，设置为YES
//    securityPolicy.validatesDomainName = YES;
    // 添加证书
    //    [securityPolicy setPinnedCertificates:cerSet];
    
//    manager.securityPolicy = securityPolicy;
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary * array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
             NSLog(@"OK === %@",array);
             NSString *htmlString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
             NSLog(@"%@",htmlString);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"error ==%@",error.description);
         }];
}

@end
