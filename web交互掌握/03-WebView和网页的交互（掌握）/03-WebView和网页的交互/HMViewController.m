//
//  HMViewController.m
//  03-WebView和网页的交互
//
//  Created by apple on 14-9-29.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMViewController.h"

@interface HMViewController () <UIWebViewDelegate>

@end

@implementation HMViewController

/**
 test.html存在于服务器，里面的html和js代码，我们是无法修改的

 如果test.html显示在手机端，把那个ul去掉
 
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 1.webView
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    webView.scalesPageToFit = YES;
    
    // 2.加载网页
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:8080/MJServer/resources/htmls/test.html"]];
    [webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 利用webView执行js代码，操作网页中的节点
    NSString *js1 = @"var ul = document.getElementsByTagName('ul')[0];";
    NSString *js2 = @"ul.parentNode.removeChild(ul);";
    
    [webView stringByEvaluatingJavaScriptFromString:js1];
    [webView stringByEvaluatingJavaScriptFromString:js2];
}

@end
