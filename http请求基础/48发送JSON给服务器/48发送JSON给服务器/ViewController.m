//
//  ViewController.m
//  48发送JSON给服务器
//
//  Created by Mac OS X on 15/9/20.
//  Copyright (c) 2015年 Mac OS X. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD+CZ.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/MJServer/order"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    //4.设置请求体，创建一个描述订单信息的JSON
    
    NSDictionary *json = @{
                           @"shop_id" : @"1234",
                           @"shop_name" : @"优乐美",
                           @"user_id" : @"110"
                           };
    
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    
    //5.设置请求头：这次的请求体不再是普通的参数，而是一个JSON数据
    /*
     MIMEType : 请求体的数据类型
     image/jpng
     image/png
     */
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //6.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data == nil || connectionError) {
            [MBProgressHUD showError:@"请求失败"];
            return ;
        }
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *error = json[@"error"];
        if (error) {
            [MBProgressHUD showError:error];
        }else{
            [MBProgressHUD showSuccess:json[@"success"]];
        }
    }];
}

@end
