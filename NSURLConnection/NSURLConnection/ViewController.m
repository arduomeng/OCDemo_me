//
//  ViewController.m
//  NSURLConnection
//
//  Created by Apple on 16/4/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSURLConnection sendAsynchronousRequest:<#(nonnull NSURLRequest *)#> queue:<#(nonnull NSOperationQueue *)#> completionHandler:<#^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError)handler#>]
}



@end
