//
//  ViewController.m
//  CS相册选择
//
//  Created by arduomeng on 16/11/4.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import "ViewController.h"
#import "CSUIImagePickerController.h"
#import "UIViewController+Util.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)onClickAddPhoto:(id)sender {
    CSUIImagePickerController *ipVC = [CSUIImagePickerController initFromStoryboard:[CSUIImagePickerController class]];
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:ipVC];
    
    [self presentViewController:navc animated:YES completion:nil];
}


@end
