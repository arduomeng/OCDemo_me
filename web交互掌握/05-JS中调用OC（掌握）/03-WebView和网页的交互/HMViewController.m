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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 1.webView
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    // 2.加载网页
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{

}

/**
 *  webView每当发送一个请求之前，都会先调用这个方法（能拦截所有请求）
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    NSRange range = [url rangeOfString:@"hm://"];
    NSUInteger loc = range.location;
    if (loc != NSNotFound) { // url的协议头是hm
        // 方法名
        NSString *method = [url substringFromIndex:loc + range.length];
        
        // 转成SEL
        SEL sel = NSSelectorFromString(method);
        [self performSelector:sel withObject:nil];
    }
    return YES;
}

/**
 *  打电话
 */
- (void)call
{
    NSLog(@"call----");
}

/**
 *  打开照相机
 */
- (void)openCamera
{
    NSLog(@"openCamera----");
}

@end
