//
//  Person_Extension.h
//  OC权限管理
//
//  Created by arduomeng on 16/12/12.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import "Person.h"

@interface Person ()
{
    // 成员变量
    NSString *addressExt;
    
}

// 属性
@property (nonatomic, copy) NSString *detailAddressExt;
// 方法
- (void)getDetailInfo;
@end
