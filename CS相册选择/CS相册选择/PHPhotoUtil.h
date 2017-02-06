//
//  PHPhotoUtil.h
//  VideoShow
//
//  Created by arduomeng on 16/12/29.
//  Copyright © 2016年 energy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class PHAsset;

typedef void (^resultHandlerExactImage)(UIImage * result, NSDictionary * info);
typedef void (^resultHandlerImageURL)(NSURL * url, NSDictionary * info);

@interface PHPhotoUtil : NSObject

+ (void)requestExactImageAsync:(PHAsset *)asset size:(CGSize)size resultHandler:(resultHandlerExactImage)block;
+ (void)requestExactImageSync:(PHAsset *)asset size:(CGSize)size resultHandler:(resultHandlerExactImage)block;
+ (void)requestThumbnailImage:(PHAsset *)asset resultHandler:(resultHandlerExactImage)block;
+ (void)requestThumbnailImageSync:(PHAsset *)asset resultHandler:(resultHandlerExactImage)block;
+ (void)requestImageURL:(PHAsset *)asset resultHandler:(resultHandlerImageURL)block;
+ (void)requestVideoURL:(PHAsset *)asset resultHandler:(resultHandlerImageURL)block;

+ (PHAsset *)fetchAssetWithIdentifier:(NSString *)indentifier;

+(void)saveVideoFromURL:(NSURL *)url  toAlbum:(NSString *)customAlbumName  completionBlock:(void (^)(PHAsset *phasset))completionBlock  failureBlock:(void (^)(NSError *error))failureBlock;

+ (float)getVideoFilesize:(NSURL *)url;
+ (void)getVideoFilesizeWithPHAsset:(PHAsset *)phasset block:(void(^)(float assetSize))block;
@end
