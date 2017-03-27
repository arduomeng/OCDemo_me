//
//  CSDownloadManager.h
//  多任务断点下载
//
//  Created by arduomeng on 17/2/28.
//  Copyright © 2017年 arduomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CSSingleton.h"
#import "CSDownload.h"


@interface CSDownloadManager : NSObject

CSSingletonH

- (void)downloadDataWithURL:(NSURL *)URL resume:(BOOL)resume progress:(progressBlock)progressBlock status:(statusBlock)statusBlock;
@end
