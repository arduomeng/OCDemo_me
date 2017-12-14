//
//  ViewController.m
//  44基本的http请求
//
//  Created by Mac OS X on 15/9/20.
//  Copyright (c) 2015年 Mac OS X. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD+CZ.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)btnLoginClick;


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

- (IBAction)btnLoginClick {
    
    NSString *txtName = self.txtName.text;
    NSString *txtPass = self.txtPassword.text;
    
    if (txtName.length == 0 || txtPass.length == 0) {
        [MBProgressHUD showError:@"输入不完整"];
    }else{
        ///get方式发送请求
        
        NSString *urlStr = [NSString stringWithFormat:@"http://localhost:8080/MJServer/login", txtName, txtPass];
        
        NSURL *url = [NSURL URLWithString:urlStr];
        
        //创建一个请求(不可变的请求)
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        //创建一个可变的请求
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        
        //改变请求方式
        request.HTTPMethod = @"POST";
        
        //设置请求体
        NSString *param = [NSString stringWithFormat:@"username=%@&pwd=%@", txtName, txtPass];
        request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
        
        /*
         NSMutableURLRequest常用方法
         1.request.timeoutInterval设置超时
         
         NSURLRequest由于是不可变的，不能修改超时时间。
         */
        request.timeoutInterval = 5;//默认60秒
        
        NSLog(@"---begin login");
        
        //发送一个异步请求.
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            //这个block会在请求完毕的时候会到主队列自动调用
            NSLog(@"request end");
            
            if (connectionError || data == nil) {
                [MBProgressHUD showError:@"请求失败"];
                return ;
            }
            //解析服务器返回的json数据
            //NSJSONReadingMutableLeaves返回的数据为可变的数据,一般不关心
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            NSString *error = dict[@"error"];
            if (error) {
                [MBProgressHUD showError:error];
            }else{
                NSString *str = dict[@"success"];
                [MBProgressHUD showSuccess:str];
                
                [self performSegueWithIdentifier:@"loginToVideo" sender:nil];
            }
            
        }];
        
        NSLog(@"---end login");
    }
    
}
@end
