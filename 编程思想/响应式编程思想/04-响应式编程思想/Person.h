//
//  Person.h
//  04-响应式编程思想
//
//  Created by xiaomage on 15/10/25.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
{
    @public
    NSString *_name;
}
/**  */
@property (nonatomic, strong) NSString *name;

@end
