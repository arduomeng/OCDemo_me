//
//  ViewController.m
//  字典转模型Demo
//
//  Created by LCS on 16/1/7.
//  Copyright (c) 2016年 LCS. All rights reserved.
//

#import "ViewController.h"
#import "person.h"
#import "class.h"
#import "biology.h"
#import <MJExtension.h>
#import "person1.h"
#import "class1.h"
#import "biology1.h"
#import "person2.h"
#import "class2.h"
#import "biology2.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"MJExtension");
    //字典转模型
    NSDictionary *dict = @{
                           @"name" : @"Jack",
                           @"icon" : @"lufy.png",
                           @"age" : @20,
                           @"height" : @"1.55",
                           @"money" : @100.9,
                           @"sex" : @(SexFemale),
                           @"gay" : @"true"
                           };
    person *user = [person mj_objectWithKeyValues:dict];
    NSLog(@"%@, %d, %d", user.name, user.sex, user.age);
    //模型的嵌套
    NSDictionary *dict2 = @{
                            @"user" : @{
                                    @"name" : @"Jack",
                                    @"icon" : @"lufy.png",
                                    @"age" : @20,
                                    @"height" : @"1.55",
                                    @"money" : @100.9,
                                    @"sex" : @(SexFemale),
                                    @"gay" : @"true"
                                    },
                            @"name" : @"lcs"
                            };
    biology *biol = [biology mj_objectWithKeyValues:dict2];
    NSLog(@"%@, %@", biol.user.name, biol.name);
    
    //字典数组转模型数组
    [class mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"array" : @"person"};
    }];
    
    NSDictionary *dict3 = @{
                            @"array" : @[@{
                                             @"name" : @"Jack",
                                             @"icon" : @"lufy.png",
                                             @"age" : @20,
                                             @"height" : @"1.55",
                                             @"money" : @100.9,
                                             @"sex" : @(SexFemale),
                                             @"gay" : @"true"
                                             },
                                         @{
                                             @"name" : @"rose",
                                             @"icon" : @"lufy.png",
                                             @"age" : @20,
                                             @"height" : @"1.55",
                                             @"money" : @100.9,
                                             @"sex" : @(SexFemale),
                                             @"gay" : @"true"
                                             },]
                            };
    class *c = [class mj_objectWithKeyValues:dict3];
    for (person *p in c.array) {
        NSLog(@"%@", p.name);
    }
    
    NSLog(@"============jastor============");
    
    person1 *per = [[person1 alloc] initWithDictionary:dict];
    NSLog(@"%@ ", per.name);
    
    biology1 *bio = [[biology1 alloc] initWithDictionary:dict2];
    NSLog(@"%@, %@", bio.user.name, bio.name);
    
    NSLog(@"============JSONModel============");
    person2 *per2 = [[person2 alloc] initWithDictionary:dict error:nil];
    NSLog(@"%@ ", per2.name);
    
    biology2 *bio2 = [[biology2 alloc] initWithDictionary:dict2 error:nil];
    NSLog(@"%@, %@", bio2.user.name, bio2.name);
    
    class2 *cla2 = [[class2 alloc] initWithDictionary:dict3 error:nil];
    for (person *p in cla2.array) {
        NSLog(@"%@", p.name);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
