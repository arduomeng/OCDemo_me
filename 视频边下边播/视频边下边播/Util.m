//
//  Util.m
//  视频边下边播
//
//  Created by arduomeng on 17/2/17.
//  Copyright © 2017年 arduomeng. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (NSURL *)getSchemeVideoURL:(NSURL *)url{
    
    // NSURLComponents用来替代NSMutableURL，可以readwrite修改URL
    // AVAssetResourceLoader通过你提供的委托对象去调节AVURLAsset所需要的加载资源。
    // 而很重要的一点是，AVAssetResourceLoader仅在AVURLAsset不知道如何去加载这个URL资源时才会被调用
    // 就是说你提供的委托对象在AVURLAsset不知道如何加载资源时才会得到调用。
    // 所以我们又要通过一些方法来曲线解决这个问题，把我们目标视频URL地址的scheme替换为系统不能识别的scheme
    
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
    components.scheme = @"systemCannotRecognition";
    
    return [components URL];
}
+ (NSURL *)getHttpVideoURL:(NSURL *)url{
    
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
    components.scheme = @"http";
    
    return [components URL];
}

@end
