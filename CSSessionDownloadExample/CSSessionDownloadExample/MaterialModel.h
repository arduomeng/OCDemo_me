//
//  MaterialModel.h
//  CSSessionDownloadExample
//
//  Created by user on 2017/5/16.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    StatusTypeNeedDownload = 0, //需要去下载
    StatusTypeNeedUpdate,       //需要去更新
    StatusTypeFinished,         //已经完成了
    StatusTypeDownloading,      //正在下载
    StatusTypePause             //暂停下载
} StatusType;

@interface MaterialModel : NSObject

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) StatusType statusType;

@property (nonatomic, assign) float progress;
@property (nonatomic, assign) int64_t speed;


@end


