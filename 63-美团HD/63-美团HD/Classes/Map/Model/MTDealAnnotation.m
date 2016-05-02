//
//  MTDealAnnotation.m
//  63-美团HD
//
//  Created by LCS on 15/12/8.
//  Copyright (c) 2015年 Mac OS X. All rights reserved.
//

#import "MTDealAnnotation.h"

@implementation MTDealAnnotation

- (BOOL)isEqual:(MTDealAnnotation *)object
{
    return [self.title isEqualToString:object.title];
}

@end
