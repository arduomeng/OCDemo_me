//
//  CSTextField.m
//  Runtime实例
//
//  Created by Apple on 16/4/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CSTextField.h"
#import <objc/runtime.h>
@implementation CSTextField


+ (void)initialize{
    // 获取类所有的属性、变量、方法、协议
//    class_copyPropertyList(<#__unsafe_unretained Class cls#>, <#unsigned int *outCount#>)
//    class_copyIvarList(<#__unsafe_unretained Class cls#>, <#unsigned int *outCount#>)
//    class_copyMethodList(<#__unsafe_unretained Class cls#>, <#unsigned int *outCount#>)
//    class_copyProtocolList(<#__unsafe_unretained Class cls#>, <#unsigned int *outCount#>)
    
}

- (void)getProperty{
    // 运用Runtime获取TextField里面的所有属性
    unsigned int count = 0;
    // 返回属性数组的指针
    objc_property_t *property = class_copyPropertyList([UITextField class], &count);
    
    for(unsigned int i = 0; i < count; i++){
        NSLog(@"%s %s", property_getName(property[i]), property_getAttributes(property[i]));
    }
    
    // 释放内存
    free(property);
}

- (void)getMethodList{
    // 运用Runtime获取TextField里面的所有属性
    unsigned int count = 0;
    // 返回属性数组的指针
    Method *property = class_copyMethodList([UIScrollView class], &count);
    
    for(unsigned int i = 0; i < count; i++){
        NSLog(@"%@", NSStringFromSelector(method_getName(property[i])));
    }
    
    // 释放内存
    free(property);
}

- (void)getIvars{
    // 运用Runtime获取TextField里面的所有成员变量Ivar 此处用到_placeholderLabel
    unsigned int count = 0;
    // 返回变量数组的指针
    Ivar *ivar = class_copyIvarList([UITextField class], &count);
    
    for(unsigned int i = 0; i < count; i++){
        NSLog(@"%s %s", ivar_getName(ivar[i]) , ivar_getTypeEncoding(ivar[i]));
    }
    
    // 释放内存
    free(ivar);
}

- (void)awakeFromNib{
    // 设置光标颜色
    self.tintColor = [UIColor blackColor];
    
    [self resignFirstResponder];
    
//    [self getIvars];
    
    [self getMethodList];
}

- (BOOL)becomeFirstResponder{
    
    UILabel *palceholderLabel = [self valueForKey:@"_placeholderLabel"];
    palceholderLabel.textColor = [UIColor redColor];
    
    [self setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder{
    
//    UILabel *palceholderLabel = [self valueForKey:@"_placeholderLabel"];
//    palceholderLabel.textColor = [UIColor yellowColor];
    
    
    [self setValue:[UIColor yellowColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    return [super resignFirstResponder];
}

@end
