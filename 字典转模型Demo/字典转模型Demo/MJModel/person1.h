//
//  person.h
//  字典转模型Demo
//
//  Created by LCS on 16/1/7.
//  Copyright (c) 2016年 LCS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Jastor.h>
@interface person1 : Jastor
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *icon;
@property (assign, nonatomic) unsigned int age;
@property (copy, nonatomic) NSString *height;
@property (strong, nonatomic) NSNumber *money;
@property (assign, nonatomic) enum {
                                        SexMale,
                                        SexFemale
                                    } sex;
@property (assign, nonatomic, getter=isGay) BOOL gay;
@end
