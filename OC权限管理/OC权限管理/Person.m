//
//  Person.m
//  OC权限管理
//
//  Created by arduomeng on 16/12/12.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import "Person.h"
#import "Person_Extension.h"

@implementation Person
{
    // 私有成员变量 成员变量既可以再interface中定义，也可以在implementation中定义
    // 并且和private修饰的不太一样。在其它类中无法查看,也无法访问，只能在本类中访问
}
// 私有方法
- (void)getInfo{
    NSLog(@"Person getInfo");
}

- (void)getDetailInfo{
    NSLog(@"Person getDetailInfo");
}
@end
