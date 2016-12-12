//
//  NSObject+Runtime.h
//  OC权限管理
//
//  Created by arduomeng on 16/12/12.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Runtime)
+ (void)getProperty;
+ (void)getIvars;
+ (void)getMethod;
@end
