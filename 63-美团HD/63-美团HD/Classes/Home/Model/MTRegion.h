//
//  MTRegion.h
//  美团HD
//
//  Created by apple on 14/11/23.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTRegion : NSObject
/** 区域名字 */
@property (nonatomic, copy) NSString *name;
/** 子区域 */
@property (nonatomic, strong) NSArray *subregions;
@end
