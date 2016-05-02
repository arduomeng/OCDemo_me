//
//  MTCityGroup.h
//  美团HD
//
//  Created by apple on 14/11/23.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTCityGroup : NSObject
/** 这组的标题 */
@property (nonatomic, copy) NSString *title;
/** 这组的所有城市 */
@property (nonatomic, strong) NSArray *cities;
@end
