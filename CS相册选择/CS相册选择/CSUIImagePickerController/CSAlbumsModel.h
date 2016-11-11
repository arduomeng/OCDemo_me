//
//  CSAlbumsModel.h
//  CS相册选择
//
//  Created by arduomeng on 16/11/9.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface CSAlbumsModel : NSObject

@property (nonatomic, strong) PHFetchResult *results;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger count;

+ (instancetype)albumModelWith:(PHFetchResult *)results name:(NSString *)name;

@end
