//
//  CSFileManager.m
//  视频边下边播
//
//  Created by arduomeng on 17/2/17.
//  Copyright © 2017年 arduomeng. All rights reserved.
//

#import "CSFileManager.h"

@implementation CSFileManager

/** 相对沙盒目录的documents路径 */
+ (NSString *) relativeSandboxDocPath:(NSString *)srcPath
{
    NSString * docPath = kPathDocument;
    //找到第一个Documents目录之前的路径,移除之后添加新的documents路径
    NSRange range = [srcPath rangeOfString:@"Documents/" options:NSLiteralSearch];//区分大小写
    NSString * relativePath = srcPath;
    if (range.location != NSNotFound) {
        relativePath = [srcPath substringFromIndex:range.location+range.length];
    }
    NSString * filePath = [docPath stringByAppendingPathComponent:relativePath];
    return filePath;
}

+(NSString*)createDirIfNotExists:(NSString *)dirPath
{
    if(![self fileExists:dirPath]){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL ret = [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!ret){
            dirPath = nil;
        }
    }
    return dirPath;
}
// 判断文件目录存在
+(BOOL)fileExists:(NSString*)file
{
    BOOL exists = NO;
    if(file && [file isKindOfClass:[NSString class]] && ![file isEqualToString:@""]){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        exists = [fileManager fileExistsAtPath:file];
    }
    return exists;
}
@end
