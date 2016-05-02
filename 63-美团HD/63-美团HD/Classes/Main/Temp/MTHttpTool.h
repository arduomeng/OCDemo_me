//
//  MTHttpTool.h
//  63-美团HD
//
//  Created by LCS on 15/12/8.
//  Copyright (c) 2015年 Mac OS X. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTHttpTool : NSObject

- (void)request:(NSString *)url pamras:(NSMutableDictionary *)params success:(void (^) (id json))success failure:(void (^)(NSError *error))failure;

@end
