//
//  MTCity.m
//  美团HD
//
//  Created by apple on 14/11/23.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "MTCity.h"
#import "MJExtension.h"
#import "MTRegion.h"

@implementation MTCity
- (NSDictionary *)objectClassInArray
{
    return @{@"regions" : [MTRegion class]};
}
@end
