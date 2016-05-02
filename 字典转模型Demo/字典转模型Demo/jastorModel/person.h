//
//  person.h
//  字典转模型Demo
//
//  Created by LCS on 16/1/7.
//  Copyright (c) 2016年 LCS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Jastor.h>
typedef enum {
    SexMale,
    SexFemale
} Sex;
@interface person : NSObject
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *icon;
@property (assign, nonatomic) unsigned int age;
@property (copy, nonatomic) NSString *height;
@property (strong, nonatomic) NSNumber *money;
@property (assign, nonatomic) Sex sex;
@property (assign, nonatomic, getter=isGay) BOOL gay;
@end
