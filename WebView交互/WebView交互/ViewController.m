//
//  ViewController.m
//  WebView交互
//
//  Created by Apple on 16/4/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+NSInvocation.h"
//OC提供的js库
//#import <JavaScriptCore/JavaScriptCore.h>

@interface ViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goItem;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _webView loadHTMLString:<#(nonnull NSString *)#> baseURL:<#(nullable NSURL *)#>
//    _webView loadData:<#(nonnull NSData *)#> MIMEType:<#(nonnull NSString *)#> textEncodingName:<#(nonnull NSString *)#> baseURL:<#(nonnull NSURL *)#>
    
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"synthesize" withExtension:@"html"];
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    //自适应
    _webView.scalesPageToFit = YES;
    //检测特殊的字符串并高亮显示 例如：电话，网站
    _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    
    
}

//加载网页内部的url请求时也会掉用
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    //OC掉用js  stringByEvaluatingJavaScriptFromString返回值为js的返回值
    NSString *title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"%@", title);
}


//每当webview即将发送请求之前，就会调用。JS调用OC的桥梁
//JS OC交互第三方：WebViewJavaScriptBridge
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    NSString *urlProtocol = @"lcs://";
    if ([url hasPrefix:urlProtocol]) {
        NSString *methodStr = [url substringFromIndex:urlProtocol.length];
        NSString *method = [[methodStr componentsSeparatedByString:@"?"] firstObject];
        NSString *paramStr = [[methodStr componentsSeparatedByString:@"?"] lastObject];
        NSArray *paramArr = [paramStr componentsSeparatedByString:@"&"];
        
        NSString *returnValue = [self performSelector:NSSelectorFromString(method) withObjects:paramArr];
        NSLog(@"%@", returnValue);
        return NO;
    }
    
    return YES;
}

- (NSString *)callParam1:(NSString *)param1 param2:(NSString *)param2{
    NSLog(@"%s %@ %@", __func__, param1, param2);
    return @"callParam1param2";
}



@end
