//
//  Person+category.h
//  OC权限管理
//
//  Created by arduomeng on 16/12/12.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import "Person.h"

@interface Person (category)

// 只能添加方法， 不能添加属性(成员变量) (可以通过runtime来实现)
// 只会生成setter/getter方法的声明， 不会生成实现以及私有成员变量
//@property (nonatomic, copy) NSString *phone;

@end
