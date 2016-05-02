//
//  MTTempViewController.m
//  63-美团HD
//
//  Created by LCS on 15/12/8.
//  Copyright (c) 2015年 Mac OS X. All rights reserved.
//

#import "MTTempViewController.h"
#import "MTHttpTool.h"
//#import "DPAPI.h"
//@interface MTTempViewController ()<DPRequestDelegate>
//
//@property(nonatomic, strong) DPRequest *request1;
//@property(nonatomic, strong) DPRequest *request2;
//@property(nonatomic, strong) DPRequest *request3;
//@property(nonatomic, strong) DPRequest *request4;
//
//
//@end

@implementation MTTempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    DPAPI *api = [[DPAPI alloc] init];
//    
//    self.request1 = [api requestWithURL:@"xxx1" params:nil delegate:self];
//    self.request2 = [api requestWithURL:@"xxx2" params:nil delegate:self];
//    self.request3 = [api requestWithURL:@"xxx3" params:nil delegate:self];
//    self.request4 = [api requestWithURL:@"xxx4" params:nil delegate:self];
    
    
    MTHttpTool *httpTool = [[MTHttpTool alloc] init];
    [httpTool request:@"xxx1" pamras:nil success:^(id json) {
        //
    } failure:^(NSError *error) {
        //
    }];
    
    [httpTool request:@"xxx2" pamras:nil success:^(id json) {
        //
    } failure:^(NSError *error) {
        //
    }];
    
    [httpTool request:@"xxx3" pamras:nil success:^(id json) {
        //
    } failure:^(NSError *error) {
        //
    }];
}

//- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
//{
//    if (request == self.request1) {
//        //
//    }
//    if (request == self.request2) {
//        //
//    }
//}
@end
