//
//  ViewController.m
//  Quartz 2D
//
//  Created by LCS on 16/7/16.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "ViewController.h"
#import "RedView.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISlider *SlideBar;
@property (weak, nonatomic) IBOutlet RedView *RedView;

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
- (IBAction)SlideBarChange:(UISlider *)sender {
    
    NSLog(@"%f", sender.value);
    
    _RedView.progress = sender.value;
}

@end
