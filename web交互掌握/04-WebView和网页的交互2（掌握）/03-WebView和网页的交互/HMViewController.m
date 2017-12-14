//
//  HMViewController.m
//  03-WebView和网页的交互
//
//  Created by apple on 14-9-29.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMViewController.h"

@interface HMViewController () <UIWebViewDelegate>
@property (nonatomic, weak) UIActivityIndicatorView *loadingView;
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
    // 伸缩页面至填充整个webView
    webView.scalesPageToFit = YES;
    // 隐藏scrollView
    webView.scrollView.hidden = YES;
    [self.view addSubview:webView];
    
    // 2.加载网页
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.dianping.com/tuan/deal/5501525"]];
    [webView loadRequest:request];
    
    // 3.创建
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loadingView startAnimating];
    loadingView.center = CGPointMake(160, 240);
    [self.view addSubview:loadingView];
    self.loadingView = loadingView;
}

// OC -> JS
// 在OC中调用JS

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 执行JS代码，将大众点评网页里面的多余的节点删掉
//    var html =  document.body.innerHTML;
//    NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML;"];
//    NSLog(@"%@", html);
    
    NSMutableString *js1 = [NSMutableString string];
    // 0.删除顶部的导航条
    [js1 appendString:@"var header = document.getElementsByTagName('header')[0];"];
    [js1 appendString:@"header.parentNode.removeChild(header);"];
    
    // 1.删除底部的链接
    [js1 appendString:@"var footer = document.getElementsByTagName('footer')[0];"];
    [js1 appendString:@"footer.parentNode.removeChild(footer);"];
    [webView stringByEvaluatingJavaScriptFromString:js1];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableString *js2 = [NSMutableString string];
        // 2.删除浮动的广告
        [js2 appendString:@"var list = document.body.childNodes;"];
        [js2 appendString:@"var len = list.length;"];
        [js2 appendString:@"var banner = list[len - 1];"];
        [js2 appendString:@"banner.parentNode.removeChild(banner);"];
        [webView stringByEvaluatingJavaScriptFromString:js2];
        
        // 显示scrollView
        webView.scrollView.hidden = NO;
        
        // 删除圈圈
        [self.loadingView removeFromSuperview];
    });
}

@end
