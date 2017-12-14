//
//  LCSVideo.m
//  44基本的http请求
//
//  Created by Mac OS X on 15/9/20.
//  Copyright (c) 2015年 Mac OS X. All rights reserved.
//

#import "LCSVideo.h"

@implementation LCSVideo


+ (instancetype) video:(NSDictionary *)dict
{
    LCSVideo *video = [[self alloc] init];
    
    [video setValuesForKeysWithDictionary:dict];
    
    return  video;
}

@end
