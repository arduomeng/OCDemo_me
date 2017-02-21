//
//  CSFileManager.h
//  视频边下边播
//
//  Created by arduomeng on 17/2/17.
//  Copyright © 2017年 arduomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

//获取temp
#define kPathTemp NSTemporaryDirectory()

//获取沙盒 Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

//获取沙盒 Cache
#define kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

@interface CSFileManager : NSObject
// 根据将原路径转换成当前沙盒路径
+ (NSString *) relativeSandboxDocPath:(NSString *)srcPath;

+(NSString*)createDirIfNotExists:(NSString *)dirPath;

+(BOOL)fileExists:(NSString*)file;
@end
