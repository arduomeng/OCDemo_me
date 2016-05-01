//
//  TableViewController.m
//  01-新浪
//
//  Created by apple on 14/11/2.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController



#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"User-%zd", indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%s", __func__);
    NSLog(@"授权界面 %@", self.callScheme);
    
    // 跳转会网易新闻客户端, 并且将授权信息返回给网易新闻客户端
    
    // 1.获取application对象
    UIApplication *app = [UIApplication sharedApplication];
    // 2.创建需要打开的应用程序的URL
    // 在应用程序跳转中, 只要有协议头即可, 路径可有可无
    NSString *str = [NSString stringWithFormat:@"%@://login?user=%zd", self.callScheme , indexPath.row];
    NSURL *url = [NSURL URLWithString:str];
    // 3.利用application打开URL
    if ([app canOpenURL:url]) {
        // 3.1判断是否可以打开
        [app openURL:url];
        
        // 出栈
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else
    {
        // 3.2打开App STORE下载
        NSLog(@"根据App id打开App STORE");
    }
}
@end
