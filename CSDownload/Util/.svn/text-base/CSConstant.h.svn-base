//
//  CSConstant.h
//  VideoShow
//
//  Created by arduomeng on 17/4/20.
//  Copyright © 2017年 energy. All rights reserved.
//

#import <Foundation/Foundation.h>

//文件大小存储字典 记录需下载文件的大小，判断文件是否下载完成
#define fileDicFullPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"fileTotalSizeDic.plist"]

typedef NS_ENUM(NSUInteger, CSDownloadStatus) {
    CSDownloadStatusRunning,
    CSDownloadStatusSuspended,
    CSDownloadStatusCompleted,
    CSDownloadStatusFailed,
    CSDownloadStatusCancel,
};

@interface CSConstant : NSObject


+ (NSString *)md5:(NSString *)str;
+ (NSString *)md5OfFilePath:(NSString *)filePath;

@end
