//
//  ViewController.m
//  03-BLE
//
//  Created by dyf on 15/9/30.
//  Copyright © 2015年 dyf. All rights reserved.
//

#import "ViewController.h"

#import "XMGBLECentralController.h"
#import "XMGBLEPeripheralViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择1个模式查看";
}
- (IBAction)pushToCentral:(id)sender {
    // 跳转到central模式VC
    [self.navigationController pushViewController:[[XMGBLECentralController alloc] init] animated:YES];
}
- (IBAction)pushToPeripheral:(id)sender {
    // 跳转到peripheral模式VC
    [self.navigationController pushViewController:[[XMGBLEPeripheralViewController alloc] init] animated:YES];
}

@end
