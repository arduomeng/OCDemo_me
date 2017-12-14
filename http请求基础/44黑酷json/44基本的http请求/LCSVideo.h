//
//  LCSVideo.h
//  44基本的http请求
//
//  Created by Mac OS X on 15/9/20.
//  Copyright (c) 2015年 Mac OS X. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCSVideo : NSObject
/*
id = 2;
image = "resources/images/minion_02.png";
length = 12;
name = "\U5c0f\U9ec4\U4eba \U7b2c02\U90e8";
url = "resources/videos/minion_02.mp4";
*/


@property (nonatomic, assign) int id;
@property (nonatomic, assign) int length;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;


+ (instancetype) video:(NSDictionary *)dict;

@end
