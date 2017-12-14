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
        
        [MBProgressHUD showMessage:@"正在登入"];
        
        ///get方式发送请求
        
        NSString *urlStr = [NSString stringWithFormat:@"http://localhost:8080/MJServer/login?username=%@&pwd=%@", txtName, txtPass];
        
        //url中不能包含中文，得对中文进行转码
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", urlStr);
        
        NSURL *url = [NSURL URLWithString:urlStr];
        
        //创建一个请求(不可变的请求)
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        NSLog(@"---begin login");
        
        //发送一个异步请求.
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            [MBProgressHUD hideHUD];
            
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
