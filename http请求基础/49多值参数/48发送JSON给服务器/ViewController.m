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
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/MJServer/weather"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    //4.设置请求体，发送天气请求
    
    NSMutableString *param = [NSMutableString string];
    
    //多值参数必须这种格式使用&
    [param appendString:@"place=beijing"];
    [param appendString:@"&place=shanghai"];
    [param appendString:@"&place=shengzheng"];
    
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    
    //5.发送请求
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
            NSArray *weather = json[@"weathers"];
            
            NSLog(@"%@",weather);
        }
    }];
}

@end
