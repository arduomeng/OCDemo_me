//
//  MTBusiness.h
//  63-美团HD
//
//  Created by LCS on 15/12/8.
//  Copyright (c) 2015年 Mac OS X. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTBusiness : NSObject

//name = 北京市古代钱币展览馆,
//latitude = 39.949474,
//longitude = 116.37952,

@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) float latitude;
@property(nonatomic, assign) float longitude;

@end
