//
//  MTMetaTool.h
//  美团HD
//
//  Created by apple on 14/11/24.
//  Copyright (c) 2014年 heima. All rights reserved.
//  元数据工具类:管理所有的元数据(固定的描述数据)

#import <Foundation/Foundation.h>
@class MTCategory,MTDeal;
@interface MTMetaTool : NSObject

/**
 *  返回344个城市
 */
+ (NSArray *)cities;

/**
 *  返回所有的分类数据
 */
+ (NSArray *)categories;

/**
 *  返回所有的排序数据
 */
+ (NSArray *)sorts;

/**
 *  判断一个团购的分类类型
 *
 *  @param deal 团购模型
 *
 *  @return 所属的分类模型
 */
+ (MTCategory *)categoryWithDeal:(MTDeal *)deal;
@end
