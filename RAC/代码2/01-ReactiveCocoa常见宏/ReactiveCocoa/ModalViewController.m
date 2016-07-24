//
//  ModalViewController.m
//  ReactiveCocoa
//
//  Created by xiaomage on 15/10/26.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "ModalViewController.h"

#import "GlobeHeader.h"

@interface ModalViewController ()

@property (nonatomic, strong) RACSignal *signal;

@end

@implementation ModalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    @weakify(self);
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        @strongify(self)
        
        NSLog(@"%@",self);
        
        return nil;
    }];
    _signal = signal;
    
    
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end
