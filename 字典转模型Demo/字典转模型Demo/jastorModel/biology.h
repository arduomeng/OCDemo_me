//
//  biology.h
//  字典转模型Demo
//
//  Created by LCS on 16/1/7.
//  Copyright (c) 2016年 LCS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "person.h"
@interface biology : NSObject

@property(nonatomic, strong) person *user;
@property(nonatomic, copy) NSString *name;

@end
