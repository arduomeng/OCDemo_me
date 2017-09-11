//
//  WBDropdownViewController.m
//  56新浪微博01
//
//  Created by Mac OS X on 15/9/23.
//  Copyright (c) 2015年 Mac OS X. All rights reserved.
//

#import "WBDropdownViewController.h"

@interface WBDropdownViewController ()

@end

@implementation WBDropdownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ID = @"message_cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"dropdown %ld", indexPath.row];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

@end
