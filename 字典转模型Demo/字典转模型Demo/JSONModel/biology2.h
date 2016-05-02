//
//  biology.h
//  字典转模型Demo
//
//  Created by LCS on 16/1/7.
//  Copyright (c) 2016年 LCS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "person2.h"
#import <JSONModel.h>
@interface biology2 : JSONModel

@property(nonatomic, strong) person2 *user;
@property(nonatomic, copy) NSString *name;

@end
