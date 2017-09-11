//
//  ViewController.m
//  DropdownMenu
//
//  Created by user on 2017/8/17.
//  Copyright © 2017年 user. All rights reserved.
//

#import "ViewController.h"
#import "WBDropdownMenu.h"
#import "WBDropdownViewController.h"
#import "UIView+Extensions.h"

@interface ViewController () <WBDropdownMenuDelegate>

@property (nonatomic, strong) WBDropdownViewController *dropVc;
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

- (IBAction)centerOnclick:(id)sender {
    
    //创建下拉菜单
    WBDropdownMenu *dropdownMenu = [WBDropdownMenu dropdownMenu];

    dropdownMenu.kContentMarginU = 10;
    dropdownMenu.kContentMarginL = 22;
    dropdownMenu.kContentMarginD = 10;
    dropdownMenu.kContentMarginR = 22;
    dropdownMenu.position = MenuShowPositionC;
    
    //设置代理
    dropdownMenu.delegate = self;
    
    //创建下拉菜单控制器
    dropdownMenu.contentVc = self.dropVc;
    
    //显示
    [dropdownMenu showFrom:sender];
    
}
- (IBAction)rightOnclick:(id)sender {
    //创建下拉菜单
    WBDropdownMenu *dropdownMenu = [WBDropdownMenu dropdownMenu];
    
    dropdownMenu.kContentMarginU = 10;
    dropdownMenu.kContentMarginL = 22;
    dropdownMenu.kContentMarginD = 10;
    dropdownMenu.kContentMarginR = 22;
    dropdownMenu.position = MenuShowPositionR;
    
    //设置代理
    dropdownMenu.delegate = self;
    
    //创建下拉菜单控制器
    dropdownMenu.contentVc = self.dropVc;
    
    //显示
    [dropdownMenu showFrom:sender];
}

- (WBDropdownViewController *)dropVc{
    if (!_dropVc) {
        
        // 设置内容控制器尺寸
        _dropVc = [[WBDropdownViewController alloc] init];
        _dropVc.view.width = 100;
        _dropVc.view.height = 86;
    }
    
    return _dropVc;
}

@end
