//
//  NSObject+Runtime.m
//  OC权限管理
//
//  Created by arduomeng on 16/12/12.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import "NSObject+Runtime.h"
#import <objc/runtime.h>
@implementation NSObject (Runtime)


    // 获取类所有的属性、变量、方法、协议
    //    class_copyPropertyList(<#__unsafe_unretained Class cls#>, <#unsigned int *outCount#>)
    //    class_copyIvarList(<#__unsafe_unretained Class cls#>, <#unsigned int *outCount#>)
    //    class_copyMethodList(<#__unsafe_unretained Class cls#>, <#unsigned int *outCount#>)
    //    class_copyProtocolList(<#__unsafe_unretained Class cls#>, <#unsigned int *outCount#>)


+ (void)getProperty{
    
    unsigned int count = 0;
    // 返回属性数组的指针
    objc_property_t *property = class_copyPropertyList(self, &count);
    
    NSLog(@"getProperty -----");
    for(unsigned int i = 0; i < count; i++){
        NSLog(@"%s %s", property_getName(property[i]), property_getAttributes(property[i]));
    }
    
    // 释放内存
    free(property);
}

+ (void)getIvars{
    
    unsigned int count = 0;
    // 返回变量数组的指针
    Ivar *ivar = class_copyIvarList(self, &count);
    
    NSLog(@"getIvars -----");
    for(unsigned int i = 0; i < count; i++){
        NSLog(@"%s %s", ivar_getName(ivar[i]) , ivar_getTypeEncoding(ivar[i]));
    }
    
    // 释放内存
    free(ivar);
}

+ (void)getMethod{
    unsigned int count = 0;
    
    Method *method = class_copyMethodList(self, &count);
    
    NSLog(@"getMethod -----");
    for(unsigned int i = 0; i < count; i++){
        NSLog(@"%@ %s", NSStringFromSelector(method_getName(method[i])), method_getTypeEncoding(method[i]));
    }
    
    // 释放内存
    free(method);
}

@end
