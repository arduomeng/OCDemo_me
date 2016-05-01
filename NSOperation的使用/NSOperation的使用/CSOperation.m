//
//  CSOperation.m
//  NSOperation的使用
//
//  Created by LCS on 16/4/9.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "CSOperation.h"

@implementation CSOperation

//将线程内容放到main里面
- (void)main{
    
    //建议：由于cancel操作，需要等当前任务执行完后才有效，所以在每个耗时操作后面判断当前队列是否cancel
    if (self.isCancelled)return;
    
    for(int i = 0; i < 1; i++){
        NSLog(@"messionmain %@", [NSThread currentThread]);
    }
    
}

@end
