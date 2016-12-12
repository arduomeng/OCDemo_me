//
//  Person.h
//  OC权限管理
//
//  Created by arduomeng on 16/12/12.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
{
@public
    NSString *namePub;
@protected
    int agePro;
@private
    NSString *IDPri;
    
    // 默认情况下，实例变量权限为protected
}
@end
