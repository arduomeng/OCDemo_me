//
//  ViewController.m
//  AFNetworking解析
//
//  Created by arduomeng on 17/2/27.
//  Copyright © 2017年 arduomeng. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 初始化分析-->
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] init];
    
    // GET请求分析-->
    [sessionManager GET:@"http://localhost" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    //https认证 分析
 
}

@end
