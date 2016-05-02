//
//  MTDeal.m
//  美团HD
//
//  Created by apple on 14/11/26.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "MTDeal.h"
#import "MJExtension.h"
#import "MTBusiness.h"
@implementation MTDeal
- (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"desc" : @"description"};
}

- (BOOL)isEqual:(MTDeal *)other
{
    return [self.deal_id isEqual:other.deal_id];
}

- (NSDictionary *)objectClassInArray
{
    return @{@"businesses": [MTBusiness class]};
}

MJCodingImplementation


@end
