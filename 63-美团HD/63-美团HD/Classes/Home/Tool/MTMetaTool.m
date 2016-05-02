//
//  MTMetaTool.m
//  美团HD
//
//  Created by apple on 14/11/24.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "MTMetaTool.h"
#import "MTCity.h"
#import "MTCategory.h"
#import "MTSort.h"
#import "MTDeal.h"
#import "MJExtension.h"

@implementation MTMetaTool

static NSArray *_cities;
+ (NSArray *)cities
{
    if (_cities == nil) {
        _cities = [MTCity objectArrayWithFilename:@"cities.plist"];;
    }
    return _cities;
}

static NSArray *_categories;
+ (NSArray *)categories
{
    if (_categories == nil) {
        _categories = [MTCategory objectArrayWithFilename:@"categories.plist"];;
    }
    return _categories;
}

+ (MTCategory *)categoryWithDeal:(MTDeal *)deal
{
    NSString *categoryName = [deal.categories firstObject];
    
    NSArray *categories = [self categories];
    for (MTCategory *category in categories) {
        if ([category.name isEqualToString:categoryName] || [category.subcategories containsObject:categoryName]) return category;
        
    }
    return nil;
}

static NSArray *_sorts;
+ (NSArray *)sorts
{
    if (_sorts == nil) {
        _sorts = [MTSort objectArrayWithFilename:@"sorts.plist"];;
    }
    return _sorts;
}


@end
