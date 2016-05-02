//
//  ShouquanViewController.m
//  应用程序跳转－02
//
//  Created by LCS on 15/12/9.
//  Copyright (c) 2015年 LCS. All rights reserved.
//

#import "ShouquanViewController.h"

@interface ShouquanViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ShouquanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark 数据源方法-
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    static NSString *cellID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"user-%ld", indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //  获取application对象，
    UIApplication *app = [UIApplication sharedApplication];
    //  创建需要打开的应用程序的url，
    NSString *str = [NSString stringWithFormat:@"%@://user=%ld",self.callScheme, indexPath.row];
    NSLog(@"str = %@", str);
    NSURL *url = [NSURL URLWithString:str];
    //  应用application打开url
    if ([app canOpenURL:url]) {
        
        //清空栈里面的控制器
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        [app openURL:url];
    }else
    {
        NSLog(@"无法打开应用程序01");
    }
}



@end
