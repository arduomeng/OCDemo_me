//
//  main.m
//  OC权限管理
//
//  Created by arduomeng on 16/12/12.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import "Arduomeng.h"
#import "NSObject+Runtime.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        Person *per = [[Person alloc] init];
        per->namePub = @"per";
//        per->agePro;
//        per->IDPri;
        
        Arduomeng *ard = [[Arduomeng alloc] init];
        ard->namePub = @"ard";
//        ard->IDPri;
//        ard->agePro;
        
        // 访问私有方法
        [per performSelector:@selector(getInfo) withObject:nil];
        
        [Person getProperty];
        [Person getIvars];
        [Person getMethod];
        [per setValue:@"泰和路" forKey:@"addressExt"];
        [per setValue:@"19941212" forKey:@"IDPri"];
        
        NSLog(@"addressExt : %@",[per valueForKey:@"addressExt"]);
        NSLog(@"IDPri : %@",[per valueForKey:@"IDPri"]);
        
    }
    return 0;
}

