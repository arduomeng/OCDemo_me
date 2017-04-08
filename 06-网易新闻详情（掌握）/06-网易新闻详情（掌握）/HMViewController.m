//
//  HMViewController.m
//  06-网易新闻详情（掌握）
//
//  Created by apple on 14-9-29.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMViewController.h"

@interface HMViewController ()

@end

@implementation HMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.url
    // http://c.m.163.com/nc/article/A7A94MCL00963VRO/full.html
    NSURL *url = [NSURL URLWithString:@"http://c.m.163.com/nc/article/A7AQOT560001124J/full.html"];
    
    // 2.requets
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 3.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *news = dict[@"A7AQOT560001124J"];
        [self showNews:news];
    }];
}

- (void)showNews:(NSDictionary *)news
{
    // 1.取出网页内容
    NSString *body = news[@"body"];
    
    // 2.取出图片
    NSDictionary *img = [news[@"img"] lastObject];
    NSString *imgHTML = [NSString stringWithFormat:@"<img src=\"%@\" width=\"300\" height=\"171\">", img[@"src"]];
    
    // 2.创建一个webView，显示网页
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    [self.view addSubview:webView];
    
    // 3.拼接网页内容
    NSString *html = [body stringByReplacingOccurrencesOfString:img[@"ref"] withString:imgHTML];
    
    // 4.取出新闻标题
    NSString *title = news[@"title"];
    // 5.取出新闻的时间
    NSString *time = news[@"ptime"];
    
    // 头部内容
    NSString *header = [NSString stringWithFormat:@"<div class=\"title\">%@</div><div class=\"time\">%@</div>", title, time];
    html = [NSString stringWithFormat:@"%@%@", header, html];
    
    // 链接mainBundle中的CSS文件
    NSURL *cssURL = [[NSBundle mainBundle] URLForResource:@"news" withExtension:@"css"];
    html = [NSString stringWithFormat:@"%@<link rel=\"stylesheet\" href=\"%@\">", html, cssURL];
    
    // 5.加载网页内容
    [webView loadHTMLString:html baseURL:nil];
}

@end
