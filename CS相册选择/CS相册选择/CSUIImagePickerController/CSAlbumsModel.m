//
//  CSAlbumsModel.m
//  CS相册选择
//
//  Created by arduomeng on 16/11/9.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import "CSAlbumsModel.h"

@implementation CSAlbumsModel

+ (instancetype)albumModelWith:(PHFetchResult *)results name:(NSString *)name{
    
    CSAlbumsModel *model = [[CSAlbumsModel alloc] init];
    model.results = results;
    model.name = name;
    model.count = results.count;
    
    return model;
}

@end
