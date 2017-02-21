//
//  Util.h
//  视频边下边播
//
//  Created by arduomeng on 17/2/17.
//  Copyright © 2017年 arduomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+ (NSURL *)getSchemeVideoURL:(NSURL *)url;
+ (NSURL *)getHttpVideoURL:(NSURL *)url;
@end
