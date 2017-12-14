//
//  ViewController.m
//  HTTPS适配
//
//  Created by arduomeng on 17/2//Users/admin/Desktop/temp/OCDemo_me/HTTPS适配/Podfile6.
//  Copyright © 2017年 arduomeng. All rights reserved.
//

/*  如果你用的是付费的公信机构颁发的证书，标准的https，那么无论你用的是AF还是NSUrlSession,什么都不用做，代理方法也不用实现。你的网络请求就能正常完成。
    如果你用的是自签名的证书:
    1首先你需要在plist文件中，设置可以返回不安全的请求（关闭该域名的ATS）。
    2其次，如果是NSUrlSesion，那么需要在代理方法didReceiveChallenge
    3如果是AF，你则需要设置policy 当然还可以根据需求，你可以去验证证书或者公钥，前提是，你把自签的服务端证书，或者自签的CA根证书导入到项目中：
 

 */

#import "ViewController.h"
#import <AFNetworking.h>
@interface ViewController () <NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate>

@end

@implementation ViewController
//NSString *urlString = @"https://www.12306.cn/mormhweb/";
//NSString *urlString = @"https://www.github.com";
NSString *urlString = @"https://kyfw.12306.cn/otn/";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self afnRequest];
    [self sessionRequest];
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
    NSLog(@"challenge %@",challenge.protectionSpace);
    
    
    /*
     NSURLSessionAuthChallengeUseCredential 使用证书
     NSURLSessionAuthChallengePerformDefaultHandling  忽略证书 默认的做法
     NSURLSessionAuthChallengeCancelAuthenticationChallenge 取消请求,忽略证书
     NSURLSessionAuthChallengeRejectProtectionSpace 拒绝,忽略证书
     */
    
    
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    // 创建证书
    NSURLCredential *credential = nil;
    // 判断是否是受信任的证书
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        if (credential) {
            disposition = NSURLSessionAuthChallengeUseCredential;
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    } else {
        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    }
    
    if (completionHandler) {
        // 安装证书
        completionHandler(disposition, credential);
    }
    
    
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    //5.解析数据
    NSLog(@"解析数据 %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
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
//    // 如果需要验证域名，不是必须的，但是如果写YES，则必须导入证书。
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
