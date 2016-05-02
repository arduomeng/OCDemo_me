//
//  MTHttpTool.m
//  63-美团HD
//
//  Created by LCS on 15/12/8.
//  Copyright (c) 2015年 Mac OS X. All rights reserved.
//

#import "MTHttpTool.h"
#import "DPAPI.h"

@interface MTHttpTool ()<DPRequestDelegate>

@end

@implementation MTHttpTool

static DPAPI *_api;

+ (void)initialize{
    _api = [[DPAPI alloc] init];
}

- (void)request:(NSString *)url pamras:(NSMutableDictionary *)params success:(void (^) (id json))success failure:(void (^)(NSError *error))failure
{
    DPRequest *request = [_api requestWithURL:url params:params delegate:self];
    request.success = success;
    request.failure = failure;
}

/*
 给request对象
 #warning 增加2个请求的block
 @property (nonatomic, copy) void (^success)(id json);
 @property (nonatomic, copy) void (^failure)(NSError *error);
 */

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    if (request.failure) {
        request.failure(error);
    }
}
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    if (request.success) {
        request.success(result);
    }
}



@end
