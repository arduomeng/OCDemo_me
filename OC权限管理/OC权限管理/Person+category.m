//
//  Person+category.m
//  OC权限管理
//
//  Created by arduomeng on 16/12/12.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import "Person+category.h"

@implementation Person (category)

- (void)setInfo{
    
    // 分类可以访问原有类中.h中的属性
    self->namePub = @"per";
    self->agePro = 12;
    self->IDPri = @"14";
    
}

@end
